class PartnerMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM", "no-reply@designd.co.kr")

  def new_lead(partner, client, agency)
    @partner = partner
    @client  = client
    @agency  = agency
    @dashboard_url = "https://designd.co.kr/admin"

    mail(
      to: @partner.email,
      subject: "[디어스] 새 소상공인 고객이 홈페이지를 신청했습니다 🎯"
    )
  end
end
