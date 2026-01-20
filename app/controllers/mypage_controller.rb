class MypageController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @orders = @user.orders.order(created_at: :desc)
    @liked_templates = @user.liked_templates
    
    # 임시 홈페이지 현황 데이터 (나중에 실제 데이터와 연동)
    @my_websites = []
    # 예시: @my_websites = Website.where(user: @user)
  end
end
