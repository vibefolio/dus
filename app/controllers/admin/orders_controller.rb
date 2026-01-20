class Admin::OrdersController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_order, only: [:show, :update_status]

  def index
    @orders = Order.preload(:user).order(created_at: :desc).page(params[:page]).per(20)
  rescue NameError
    @orders = Order.preload(:user).order(created_at: :desc)
  end

  def show
  end

  def update_status
    if @order.update(status: params[:status])
      redirect_to admin_order_path(@order), notice: "주문 상태가 변경되었습니다."
    else
      redirect_to admin_order_path(@order), alert: "상태 변경에 실패했습니다."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
