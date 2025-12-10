class Admin::QuotesController < ApplicationController
  layout "admin"
  http_basic_authenticate_with name: ENV.fetch("ADMIN_USERNAME", "admin"), password: ENV.fetch("ADMIN_PASSWORD", "password123")
  before_action :set_quote, only: [ :show ]

  def index
    @quotes = Quote.order(created_at: :desc)
  end

  def show
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end
end
