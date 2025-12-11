class Admin::DashboardController < ApplicationController
  layout "admin"
  layout "admin"
  before_action :authenticate_admin!

  def index
    @portfolios_count = Portfolio.count
    @quotes_count = Quote.count
    @pending_quotes_count = Quote.where(status: "pending").count
    @recent_portfolios = Portfolio.order(created_at: :desc).limit(5)
    @recent_quotes = Quote.order(created_at: :desc).limit(5)
  end
end
