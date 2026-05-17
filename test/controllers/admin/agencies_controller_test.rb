require "test_helper"

class Admin::AgenciesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:super_admin)
  end

  test "어드민 에이전시 목록" do
    get admin_agencies_url
    assert_response :success
  end

  test "어드민 새 에이전시 폼" do
    get new_admin_agency_url
    assert_response :success
  end

  test "어드민 에이전시 상세" do
    get admin_agency_url(agencies(:main_agency))
    assert_response :success
  end

  test "비로그인 어드민 차단" do
    sign_out users(:super_admin)
    get admin_agencies_url
    assert_response :redirect
  end

  test "일반 유저 어드민 차단" do
    sign_out users(:super_admin)
    sign_in users(:regular_user)
    get admin_agencies_url
    assert_response :redirect
  end
end
