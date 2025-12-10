class Admin::DashboardController < ApplicationController
  layout "admin"
  http_basic_authenticate_with name: ENV.fetch("ADMIN_USERNAME", "admin"), password: ENV.fetch("ADMIN_PASSWORD", "password123")

  def index
    @portfolios_count = Portfolio.count
    @quotes_count = Quote.count
    @pending_quotes_count = Quote.where(status: "pending").count
    @recent_portfolios = Portfolio.order(created_at: :desc).limit(5)
    @recent_quotes = Quote.order(created_at: :desc).limit(5)
  end
end
