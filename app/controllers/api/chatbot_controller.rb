module Api
  class ChatbotController < ApplicationController
    skip_before_action :verify_authenticity_token

    # POST /api/chatbot
    # 제로클로 Gateway 프록시 — 같은 Docker 네트워크 내부 통신
    def create
      token = ENV.fetch("ZEROCLAW_TOKEN", "")
      host = ENV.fetch("ZEROCLAW_HOST", "zeroclaw-dus")
      port = ENV.fetch("ZEROCLAW_PORT", "42636")

      body = JSON.parse(request.body.read) rescue {}
      message = body["message"] || ""

      if message.blank?
        render json: { error: "message is required" }, status: :bad_request
        return
      end

      begin
        uri = URI("http://#{host}:#{port}/webhook")
        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = 5
        http.read_timeout = 30

        req = Net::HTTP::Post.new(uri)
        req["Content-Type"] = "application/json"
        req["Authorization"] = "Bearer #{token}"
        req.body = { message: message }.to_json

        res = http.request(req)
        data = JSON.parse(res.body) rescue { response: res.body }

        render json: data, status: res.code.to_i
      rescue StandardError => e
        Rails.logger.error("[Chatbot] 제로클로 연결 실패: #{e.message}")
        render json: {
          response: "AI 기능이 아직 원활하지 않을 수 있어요.\n관리자에게 알림을 보냈으니 잠시 후 다시 시도해주세요."
        }, status: :service_unavailable
      end
    end
  end
end
