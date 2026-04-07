class AgencyMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM", "no-reply@designd.co.kr")

  def approved(agency)
    @agency = agency
    @owner = agency.owner
    @login_url = "https://designd.co.kr/users/sign_in"

    mail(
      to: @owner.email,
      subject: "[디어스] 에이전시 승인이 완료되었습니다 🎉"
    )
  end
end
