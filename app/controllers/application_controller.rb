class ApplicationController < ActionController::Base
  # 임시: Fly.io 프록시 문제로 인한 CSRF 검증 건너뛰기
  skip_before_action :verify_authenticity_token, raise: false
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  
  private

  def authenticate_admin!
    unless session[:admin_id]
      redirect_to new_admin_session_path, alert: "로그인이 필요합니다."
    end
  end
end
