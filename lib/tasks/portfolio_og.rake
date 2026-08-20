# 포트폴리오 카드 이미지를 각 고객사 사이트가 선언한 og:image 로 맞춘다.
#
#   bin/rails portfolio:sync_og            # 실제 반영
#   bin/rails portfolio:sync_og DRY_RUN=1  # 무엇이 바뀔지만 출력
#
# 왜 이렇게 하나
#   예전에는 image_url 에 URL 을 손으로 박아뒀는데, 그중 여러 건이 OG 가 아니라
#   사이트 내부 사진(공장 외관·행사 포스터·갤러리)이었다. 고객사가 사이트를 새로
#   만들어도 그 그림은 영영 그대로였다.
#   각 사이트가 <meta property="og:image"> 로 "우리 얼굴은 이것"이라고 이미 말하고 있으니
#   그걸 주기적으로 따라가면 우리가 따로 캡처하거나 관리할 필요가 없다.
#
# 안전 원칙 — 지금보다 나빠지지 않게 한다
#   og:image 가 없거나 / 가져오기 실패하거나 / 이미지가 아니면 DB 를 건드리지 않는다.
#   thumbnail_url 이 비면 Portfolio#card_image 가 기존 image_url 로 폴백한다.
namespace :portfolio do
  desc "각 포트폴리오 사이트의 og:image 를 읽어 thumbnail_url 갱신"
  task sync_og: :environment do
    require "net/http"
    require "uri"

    dry = ENV["DRY_RUN"].present?
    ua  = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 " \
          "(KHTML, like Gecko) Chrome/124.0 Safari/537.36"

    # 리다이렉트를 따라가며 GET. 실패는 예외 대신 nil 로 돌려주되 사유는 호출부에서 로그로 남긴다.
    fetch = lambda do |url, limit: 5, method: Net::HTTP::Get|
      return nil if limit.zero?

      uri = URI.parse(url)
      return nil unless uri.is_a?(URI::HTTP)

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https",
                            open_timeout: 10, read_timeout: 20) do |http|
        http.request(method.new(uri, "User-Agent" => ua))
      end

      if res.is_a?(Net::HTTPRedirection) && res["location"]
        fetch.call(URI.join(url, res["location"]).to_s, limit: limit - 1, method: method)
      else
        res
      end
    rescue StandardError => e
      Rails.logger.warn("[sync_og] #{url} — #{e.class}: #{e.message}")
      nil
    end

    changed = unchanged = missing = failed = 0
    seen_urls = Hash.new { |h, k| h[k] = [] }

    Portfolio.where.not(preview_url: [ nil, "" ]).order(:id).each do |p|
      res = fetch.call(p.preview_url)
      unless res.is_a?(Net::HTTPSuccess)
        puts "  #{p.id} #{p.title} — 페이지 응답 없음/오류(#{res&.code || 'timeout'}) → 유지"
        failed += 1
        next
      end

      # og:image 는 property / name 어느 쪽으로도 쓰인다. 속성 순서도 사이트마다 다르다.
      tag = res.body[/<meta[^>]+(?:property|name)=["']og:image["'][^>]*>/i] ||
            res.body[/<meta[^>]+content=["'][^"']+["'][^>]*(?:property|name)=["']og:image["'][^>]*>/i]
      raw = tag && tag[/content=["']([^"']+)["']/i, 1]

      if raw.blank?
        puts "  #{p.id} #{p.title} — og:image 미선언 → 유지 (사이트에 OG 추가 필요)"
        missing += 1
        next
      end

      og = URI.join(p.preview_url, raw).to_s

      head = fetch.call(og, method: Net::HTTP::Head)
      unless head.is_a?(Net::HTTPSuccess) && head["content-type"].to_s.start_with?("image/")
        puts "  #{p.id} #{p.title} — og:image 접근 불가(#{head&.code || 'timeout'} #{head&.[]('content-type')}) → 유지"
        failed += 1
        next
      end

      seen_urls[og] << "#{p.id} #{p.title}"

      if p.thumbnail_url == og
        unchanged += 1
        p.update_columns(thumbnail_captured_at: Time.current) unless dry
        next
      end

      puts "  #{p.id} #{p.title}"
      puts "      이전: #{p.thumbnail_url.presence || p.image_url.presence || '(없음)'}"
      puts "      이후: #{og}"
      p.update_columns(thumbnail_url: og, thumbnail_captured_at: Time.current) unless dry
      changed += 1
    end

    # 서로 다른 카드가 같은 그림을 쓰면 화면에서 중복으로 보인다.
    # 대개 하위도메인이 부모 사이트의 OG 를 그대로 상속해서 생긴다 — 고객사 쪽에서 고쳐야 한다.
    dupes = seen_urls.select { |_, owners| owners.size > 1 }
    dupes.each do |url, owners|
      puts "  ⚠️ OG 중복 — #{owners.join(' / ')}"
      puts "      #{url}"
    end

    puts
    puts "[sync_og]#{' (DRY RUN)' if dry} 변경 #{changed} / 동일 #{unchanged} / " \
         "OG없음 #{missing} / 실패 #{failed} / 중복 #{dupes.size}건"
  end
end
