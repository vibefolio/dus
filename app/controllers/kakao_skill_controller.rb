# 카카오 i 오픈빌더 스킬 어댑터
# 카카오 오픈빌더 → ZeroClaw 제로클로 프록시
#
# 오픈빌더 폴백 블록에서 이 엔드포인트를 스킬로 등록:
#   POST https://designd.co.kr/kakao-skill
#
class KakaoSkillController < ApplicationController
  skip_before_action :verify_authenticity_token

  ZEROCLAW_HOST = ENV.fetch("ZEROCLAW_HOST", "zeroclaw-dus")
  ZEROCLAW_PORT = ENV.fetch("ZEROCLAW_PORT", "42636")
  TIMEOUT = 25 # 카카오 오픈빌더 스킬 타임아웃: 5초(기본) ~ 최대 30초

  # POST /kakao-skill
  def create
    utterance = params.dig(:userRequest, :utterance).to_s.strip

    if utterance.blank?
      return render json: kakao_response("안녕하세요! 디어스입니다. 궁금한 점을 말씀해주세요.")
    end

    begin
      # 제로클로 호출
      uri = URI("http://#{ZEROCLAW_HOST}:#{ZEROCLAW_PORT}/webhook")
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5
      http.read_timeout = TIMEOUT

      req = Net::HTTP::Post.new(uri)
      req["Content-Type"] = "application/json"
      req.body = { message: utterance }.to_json

      res = http.request(req)
      data = JSON.parse(res.body) rescue {}

      reply = data["response"].to_s.strip
      # tool_code 태그 제거 (제로클로 내부 명령이 노출되는 경우)
      reply = reply.gsub(/<tool_code>.*?<\/tool_code>/m, '').strip

      if reply.blank?
        reply = "죄송해요, 답변을 준비하지 못했어요. 아래 버튼으로 직접 문의해주시면 빠르게 도와드릴게요."
      end

      render json: kakao_response(reply)

    rescue Net::OpenTimeout, Net::ReadTimeout
      render json: kakao_response(
        "응답 시간이 초과되었어요. 잠시 후 다시 시도해주시거나, 아래 버튼으로 직접 문의해주세요."
      )
    rescue => e
      Rails.logger.error("[KakaoSkill] ZeroClaw error: #{e.message}")
      render json: kakao_response(
        "AI 기능이 일시적으로 원활하지 않아요. 아래 버튼으로 직접 문의해주세요."
      )
    end
  end

  private

  # 카카오 오픈빌더 응답 JSON 포맷
  def kakao_response(text)
    {
      version: "2.0",
      template: {
        outputs: [
          { simpleText: { text: text } }
        ],
        quickReplies: [
          {
            action: "webLink",
            label: "견적 문의하기",
            webLinkUrl: "https://designd.co.kr/contact"
          },
          {
            action: "webLink",
            label: "요금제 보기",
            webLinkUrl: "https://designd.co.kr/pricing"
          },
          {
            action: "webLink",
            label: "포트폴리오",
            webLinkUrl: "https://designd.co.kr/portfolio"
          }
        ]
      }
    }
  end
end
