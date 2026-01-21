class ApplicationController < ActionController::Base
  # Fly.io 프록시 환경에서 Devise 인증 시 CSRF 문제 우회
  skip_before_action :verify_authenticity_token, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  
  before_action :set_guest_id

  private

  def set_guest_id
    unless cookies.signed[:guest_id]
      cookies.signed[:guest_id] = {
        value: SecureRandom.uuid,
        expires: 1.month.from_now
      }
    end
  end


  def authenticate_admin!
    unless session[:admin_id]
      redirect_to new_admin_session_path, alert: "로그인이 필요합니다."
    end
  end
end
