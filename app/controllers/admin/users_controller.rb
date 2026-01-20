class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(20)
  rescue NameError # kaminari가 없을 경우 대비
    @users = User.order(created_at: :desc)
  end

  def show
    @orders = @user.orders.order(created_at: :desc)
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "회원이 삭제되었습니다."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
