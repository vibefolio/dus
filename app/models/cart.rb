class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  
  # item이 Product일 수도 있고 DesignTemplate일 수도 있음
  # 직접적인 has_many :products 는 제거하거나 별도 로직 필요

  def total_price
    cart_items.sum { |cart_item| (cart_item.item&.price || 0) * cart_item.quantity }
  end
end
