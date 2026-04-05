class Api::VibersAdminController < ActionController::API
  before_action :verify_admin_secret

  def index
    stats = {
      totalUsers: User.count,
      contentCount: Order.count,
      mau: 0,
      recentSignups: User.where("created_at > ?", 7.days.ago).count
    }

    recent_activity = User.order(created_at: :desc).limit(5).map do |u|
      { id: u.id.to_s, type: "signup", label: u.email, timestamp: u.created_at }
    end

    render json: {
      projectId: "dus",
      projectName: "디어스",
      stats: stats,
      recentActivity: recent_activity,
      health: "healthy"
    }
  end

  def resource
    case params[:resource]
    when "orders"
      data = Order.order(created_at: :desc).limit(50).map do |o|
        { id: o.id.to_s, status: o.status, total: o.total_price, createdAt: o.created_at, userId: o.user_id.to_s }
      end
      render json: data
    when "agencies"
      data = Agency.order(created_at: :desc).limit(50).map do |a|
        { id: a.id.to_s, name: a.name, createdAt: a.created_at }
      end
      render json: data
    else
      render json: [], status: :ok
    end
  end

  private

  def verify_admin_secret
    unless request.headers["X-Vibers-Admin-Secret"] == ENV["VIBERS_ADMIN_SECRET"]
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
