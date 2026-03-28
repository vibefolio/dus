# 템플릿 구매 전체 플로우를 관리하는 서비스
class TemplatePurchaseService
  # 템플릿 구매: 주문 생성 → 결제 처리 → 에이전시 생성
  def self.purchase(user:, template:, payment_key: nil, order_uid: nil)
    ActiveRecord::Base.transaction do
      # 1. 주문 생성
      order = user.orders.create!(
        status: 'pending',
        total_amount: template.price,
        payment_key: payment_key,
        order_uid: order_uid
      )

      order.order_items.create!(
        design_template: template,
        quantity: 1,
        price: template.price
      )

      # 2. 결제 완료 처리
      result = OrderService.complete_payment(order)
      return result unless result[:success]

      { success: true, order: order.reload, agency: order.agency }
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message }
  end
end
