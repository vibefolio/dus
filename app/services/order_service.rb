# 주문 관련 비즈니스 로직을 관리하는 서비스
class OrderService
  # 장바구니에서 주문 생성
  def self.create_from_cart(user, cart)
    return { success: false, error: "장바구니가 비어있습니다." } if cart.nil? || cart.cart_items.empty?

    order = user.orders.build(status: 'pending', total_amount: 0)

    cart.cart_items.each do |cart_item|
      order.order_items.build(
        design_template: cart_item.design_template,
        quantity: cart_item.quantity,
        price: cart_item.design_template.price
      )
    end

    order.total_amount = order.calculate_total

    if order.save
      cart.cart_items.destroy_all
      { success: true, order: order }
    else
      { success: false, errors: order.errors }
    end
  end

  # 결제 완료 처리
  def self.complete_payment(order)
    return { success: false, error: "이미 결제 완료된 주문입니다." } if order.paid?

    ActiveRecord::Base.transaction do
      order.update!(status: 'paid')

      # 템플릿 주문인 경우 에이전시 생성
      if order.order_items.any? { |oi| oi.design_template_id.present? }
        result = AgencyManagementService.create_for_user(order.user)
        if result[:success]
          order.update!(agency: result[:agency])
        end
      end

      NotificationService.notify_order_status(order)
    end

    { success: true, order: order }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end

  # 주문 취소
  def self.cancel(order, reason: nil)
    unless order.pending?
      return { success: false, error: "대기 상태인 주문만 취소할 수 있습니다." }
    end

    if order.update(status: 'cancelled')
      NotificationService.notify_order_status(order)
      Rails.logger.info "[OrderService] 주문 취소: ##{order.id} (사유: #{reason || '없음'})"
      { success: true, order: order }
    else
      { success: false, errors: order.errors }
    end
  end
end
