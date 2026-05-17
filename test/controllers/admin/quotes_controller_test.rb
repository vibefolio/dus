require "test_helper"

class Admin::QuotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:super_admin)
  end

  test "어드민 견적 목록" do
    get admin_quotes_url
    assert_response :success
  end

  test "어드민 견적 상세" do
    get admin_quote_url(quotes(:pending_quote))
    assert_response :success
  end

  test "비로그인 어드민 견적 차단" do
    sign_out users(:super_admin)
    get admin_quotes_url
    assert_response :redirect
  end
end
