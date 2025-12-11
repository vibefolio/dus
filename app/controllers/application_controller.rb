class ApplicationController < ActionController::Base
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
