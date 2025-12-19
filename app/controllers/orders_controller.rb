class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, notice: "Order was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # Payment Success Handling
  def success
    payment_key = params[:paymentKey]
    order_id = params[:orderId]
    amount = params[:amount]
    product_id = params[:product_id]

    @product = Product.find(product_id)

    # 실제로는 여기서 토스 페이먼츠 승인 API (POST https://api.tosspayments.com/v1/payments/confirm)를 호출해야 함
    # 현재는 테스트를 위해 생략하고 바로 주문 생성

    @order = Order.new(
      product: @product,
      customer_name: "Test Customer", # 로그인 기능 연동 시 current_user.name 등 사용
      amount: amount,
      status: "paid",
      payment_key: payment_key,
      order_uid: order_id
    )

    if @order.save
      redirect_to @order, notice: "결제가 성공적으로 완료되었습니다!"
    else
      redirect_to product_path(@product), alert: "결제 처리에 실패했습니다."
    end
  end

  def fail
    error_code = params[:code]
    error_msg = params[:message]
    
    redirect_to products_path, alert: "결제 실패: #{error_msg} (#{error_code})"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.expect(order: [ :product_id, :customer_name, :amount, :status, :payment_key, :order_uid ])
    end
end
