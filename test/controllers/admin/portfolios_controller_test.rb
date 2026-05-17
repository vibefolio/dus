require "test_helper"

class Admin::PortfoliosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:super_admin)
  end

  test "어드민 포트폴리오 목록" do
    get admin_portfolios_url
    assert_response :success
  end

  test "어드민 새 포트폴리오 폼" do
    get new_admin_portfolio_url
    assert_response :success
  end

  test "어드민 포트폴리오 상세" do
    get admin_portfolio_url(portfolios(:one))
    assert_response :success
  end

  test "비로그인 어드민 포트폴리오 차단" do
    sign_out users(:super_admin)
    get admin_portfolios_url
    assert_response :redirect
  end
end
