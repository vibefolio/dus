class TossPaymentsService
  CONFIRM_URL = "https://api.tosspayments.com/v1/payments/confirm"

  def self.confirm(payment_key:, order_id:, amount:)
    secret_key = ENV.fetch("TOSS_SECRET_KEY")
    encoded = Base64.strict_encode64("#{secret_key}:")

    uri = URI(CONFIRM_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Basic #{encoded}"
    request["Content-Type"] = "application/json"
    request.body = { paymentKey: payment_key, orderId: order_id, amount: amount }.to_json

    response = http.request(request)
    body = JSON.parse(response.body)

    if response.code == "200"
      { success: true, data: body }
    else
      Rails.logger.error("[TossPaymentsService] 결제 승인 실패: #{body}")
      { success: false, code: body["code"], message: body["message"] }
    end
  rescue => e
    Rails.logger.error("[TossPaymentsService] 오류: #{e.message}")
    { success: false, code: "INTERNAL_ERROR", message: e.message }
  end
end
