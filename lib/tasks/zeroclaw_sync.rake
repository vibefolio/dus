# lib/tasks/zeroclaw_sync.rake
# 매일 실행: 디어스 DB → ZeroClaw knowledge.md 동기화
# GitHub Actions cron에서 호출

namespace :zeroclaw do
  desc "DB 현황을 ZeroClaw knowledge.md 형식으로 출력"
  task sync: :environment do
    templates = DesignTemplate.order(:category, :title).uniq.map do |t|
      "- **#{t.title}** (#{t.category}) — #{t.preview_url}"
    end.uniq

    app_portfolios = Portfolio.where(category: "앱 및 플랫폼").order(:project_date).map do |p|
      line = "- **#{p.title}**"
      line += " | #{p.client}" if p.client.present?
      line += " | #{p.preview_url}" if p.preview_url.present?
      line
    end

    web_portfolios = Portfolio.where(category: "웹사이트").order(:project_date).map do |p|
      line = "- **#{p.title}**"
      line += " | #{p.client}" if p.client.present?
      line += " | #{p.preview_url}" if p.preview_url.present?
      line
    end

    content = <<~MARKDOWN
      # 디어스 (D.US) Knowledge Base

      > ZeroClaw 챗봇 자동 동기화 — 마지막 업데이트: #{Time.current.strftime("%Y-%m-%d %H:%M KST")}
      > 이 파일은 매일 자정 자동 갱신됩니다.

      ## 개념 구분 (중요)

      ### 디자인 템플릿
      미리 만들어진 업종별 홈페이지 시안이에요. 고객이 업종에 맞는 템플릿을 고르면,
      디어스가 그 템플릿을 기반으로 빠르게 맞춤 제작해줘요.
      - 제작 기간이 짧고 비용이 상대적으로 저렴해요
      - 총 #{DesignTemplate.count}개 업종 템플릿 보유
      - 미리보기: https://d-us.co.kr/design_templates

      ### 포트폴리오 (납품 사례)
      디어스가 실제 고객에게 납품 완료한 프로젝트들이에요.
      - 웹사이트: 실제 운영 중인 클라이언트 홈페이지
      - 앱 및 플랫폼: 계발자들(Vibers)이 직접 개발·운영하는 서비스
      - 포트폴리오 보기: https://d-us.co.kr/portfolio

      ---

      ## 현재 디자인 템플릿 목록 (#{DesignTemplate.count}개)

      #{templates.join("\n")}

      ---

      ## 포트폴리오 — 앱 및 플랫폼 (#{app_portfolios.size}개)

      자체 개발·운영 중인 플랫폼 서비스예요.

      #{app_portfolios.join("\n")}

      ---

      ## 포트폴리오 — 웹사이트 납품 사례 (#{web_portfolios.size}개)

      실제 클라이언트에게 납품 완료한 웹사이트들이에요.

      #{web_portfolios.join("\n")}

      ---

      ## 요금제

      ### 베이직 플랜
      - 대상: 개인 / 포트폴리오 / 블로그
      - 초기 개발비: 100만원 (1회)
      - 유지관리비: 3만원/월
      - 포함: 랜딩페이지, 반응형 웹, 기본 문의폼, SEO 기본, 월 1회 수정

      ### 프로 플랜 (가장 인기)
      - 대상: 소상공인 / 일반 사업자
      - 초기 개발비: 200만원 (1회)
      - 유지관리비: 5만원/월
      - 포함: 브랜드 홈페이지, 마케팅 최적화, 카카오채널 연동, SEO 고급, 월 2회 수정

      ### 마스터 플랜
      - 대상: 성장 법인 / 프랜차이즈
      - 초기 개발비: 300만원~ (1회)
      - 유지관리비: 7만원/월
      - 포함: 풀 커스텀 디자인, 마케팅 자동화, 무제한 수정, 전담 디렉터, 월간 리포트

      ## 기존 홈페이지 이전

      - 단순 이전: 30만원~ (1회, 월 관리비 별도)
      - 리디자인 + 이전: 50만원~ (1회, 월 관리비 별도)
      - 풀 리빌드: 별도 견적

      ## 서비스 정보

      - URL: https://d-us.co.kr
      - 문의: duscontactus@gmail.com
      - 카카오 채널: https://pf.kakao.com/_wtCyn/chat
      - 운영: 계발자들 (Vibers) — vibers.co.kr
    MARKDOWN

    puts content
  end
end
