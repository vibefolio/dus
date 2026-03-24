require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # === Status Enum ===

  test "status enum 값 확인" do
    expected_statuses = %w[pending paid processing completed cancelled refunded]
    assert_equal expected_statuses, Order.statuses.keys
  end

  test "기본 status는 pending" do
    order = Order.new
    assert_equal "pending", order.status
  end

  test "pending? 상태 확인" do
    order = orders(:pending_order)
    assert order.pending?
    assert_not order.paid?
  end

  test "paid? 상태 확인" do
    order = orders(:paid_order)
    assert order.paid?
    assert_not order.pending?
  end

  # === 연관관계 ===

  test "belongs_to user 연관관계" do
    order = orders(:pending_order)
    assert_equal users(:regular_user), order.user
  end

  test "has_many order_items 연관관계" do
    order = orders(:pending_order)
    assert_respond_to order, :order_items
    assert_not_empty order.order_items
  end

  test "has_many design_templates through order_items" do
    order = orders(:pending_order)
    assert_respond_to order, :design_templates
  end

  # === calculate_total ===

  test "calculate_total 주문 항목 총액 계산" do
    order = orders(:pending_order)
    # pending_item: price 99000, quantity 1
    expected = order.order_items.sum { |item| item.price * item.quantity }
    assert_equal expected, order.calculate_total
  end

  test "calculate_total 주문 항목 없을 때 0" do
    order = Order.new(
      user: users(:regular_user),
      product: products(:one),
      status: "pending"
    )
    assert_equal 0, order.calculate_total
  end

  # === complete_payment! ===

  test "complete_payment! 상태를 paid로 변경" do
    order = orders(:pending_order)
    order.complete_payment!
    assert order.paid?
  end

  test "complete_payment! 이미 paid면 아무것도 안함" do
    order = orders(:paid_order)
    assert_no_difference "Agency.count" do
      order.complete_payment!
    end
    assert order.paid?
  end

  test "complete_payment! 템플릿 주문 시 에이전시 생성" do
    user = users(:regular_user)
    order = orders(:pending_order)
    # pending_order에 design_template이 있는 order_item이 연결됨

    assert_difference "Agency.count", 1 do
      order.complete_payment!
    end

    assert order.paid?
    assert_equal "owner", user.reload.role
    assert_not_nil order.reload.agency
  end

  test "complete_payment! 생성된 에이전시는 비활성 상태" do
    order = orders(:pending_order)
    order.complete_payment!

    created_agency = order.reload.agency
    assert_not_nil created_agency
    assert_not created_agency.active
  end
end
