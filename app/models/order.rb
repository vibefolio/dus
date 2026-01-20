class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product, optional: true  # 기존 호환성 유지
  has_many :order_items, dependent: :destroy
  has_many :design_templates, through: :order_items

  # 주문 상태
  enum status: {
    pending: 'pending',           # 결제 대기
    paid: 'paid',                 # 결제 완료
    processing: 'processing',     # 처리 중
    completed: 'completed',       # 완료
    cancelled: 'cancelled',       # 취소
    refunded: 'refunded'          # 환불
  }, _default: 'pending'

  # 총액 계산
  def calculate_total
    order_items.sum { |item| item.price * item.quantity }
  end

  # 주문 생성 시 총액 자동 계산
  before_save :set_total_amount, if: :new_record?

  private

  def set_total_amount
    self.total_amount ||= calculate_total
  end
end
