class Admin::PortfoliosController < ApplicationController
  layout "admin"
  http_basic_authenticate_with name: ENV.fetch("ADMIN_USERNAME", "admin"), password: ENV.fetch("ADMIN_PASSWORD", "password123")
  before_action :set_portfolio, only: [ :edit, :update, :destroy ]

  def index
    @portfolios = Portfolio.order(created_at: :desc)
  end

  def new
    @portfolio = Portfolio.new
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)

    if @portfolio.save
      redirect_to admin_portfolios_path, notice: "포트폴리오가 성공적으로 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @portfolio.update(portfolio_params)
      redirect_to admin_portfolios_path, notice: "포트폴리오가 성공적으로 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @portfolio.destroy
    redirect_to admin_portfolios_path, notice: "포트폴리오가 삭제되었습니다."
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def portfolio_params
    params.require(:portfolio).permit(:title, :description, :category, :client, :project_date, :image_url)
  end
end
