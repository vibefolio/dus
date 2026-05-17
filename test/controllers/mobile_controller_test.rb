require "test_helper"

# 모바일 전용 컨트롤러 — 라우트 미존재로 스킵
class MobileControllerTest < ActionDispatch::IntegrationTest
  test "네이티브 설정 엔드포인트 응답" do
    get "/native/config"
    assert_response :success
  end
end
