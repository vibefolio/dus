require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @owner_user = users(:owner)
    sign_in @owner_user
  end

  test "주문 목록은 마이페이지 주문으로 리다이렉트" do
    get orders_url
    assert_redirected_to mypage_orders_path
  end

  test "본인 주문 상세 조회" do
    order = orders(:paid_order)
    get order_url(order)
    assert_response :success
  end

  test "비로그인 주문 접근 차단" do
    sign_out @owner_user
    get order_url(orders(:paid_order))
    assert_redirected_to new_user_session_path
  end

  test "타인 주문 접근 시 리다이렉트" do
    # regular_user로 로그인해서 owner의 주문에 접근
    sign_out @owner_user
    sign_in users(:regular_user)
    order = orders(:paid_order)  # owner 소유 주문
    get order_url(order)
    assert_redirected_to mypage_orders_path
  end

  test "pending 주문 취소" do
    sign_out @owner_user
    sign_in users(:regular_user)
    order = orders(:pending_order)  # regular_user 소유
    delete order_url(order)
    assert_redirected_to mypage_orders_path
  end
end
