# 장바구니 → 주문 생성 시 product_id 없이도 주문 가능하도록 변경
class ChangeProductIdNullableOnOrders < ActiveRecord::Migration[8.0]
  def change
    change_column_null :orders, :product_id, true
  end
end
