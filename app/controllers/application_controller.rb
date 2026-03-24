class ApplicationController < ActionController::Base
  # OmniAuth 콜백에서만 CSRF 검증 건너뛰기 (전체 Devise 컨트롤러 아님)
  skip_before_action :verify_authenticity_token, if: :omniauth_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # 글로벌 에러 핸들링
  rescue_from ActiveRecord::RecordNotFound do |e|
    Rails.logger.warn "RecordNotFound: #{e.message}"
    redirect_to root_path, alert: "요청하신 페이지를 찾을 수 없습니다."
  end

  rescue_from ActionController::ParameterMissing do |e|
    Rails.logger.warn "ParameterMissing: #{e.message}"
    render plain: "잘못된 요청입니다. 필수 파라미터가 누락되었습니다.", status: :bad_request
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  
  before_action :set_current_agency
  before_action :link_user_to_agency

  private

  def set_current_agency
    # subdomain.designd.co.kr or subdomain.faneasy.kr 등에서 서브도메인 추출
    subdomain = request.subdomain
    if subdomain.present? && subdomain != "www"
      @current_agency = Agency.find_by(subdomain: subdomain)
    end
  end

  def link_user_to_agency
    if user_signed_in? && @current_agency && current_user.agency_id.nil?
      current_user.update(agency: @current_agency)
    end
  end

  def set_guest_id
    unless cookies.signed[:guest_id]
      cookies.signed[:guest_id] = {
        value: SecureRandom.uuid,
        expires: 1.month.from_now
      }
    end
  end


  def omniauth_controller?
    self.class.name.start_with?('Users::OmniauthCallbacks')
  end

  def authenticate_admin!
    # 1. 기존 하드코딩된 세션 체크 (유지)
    return if session[:admin_id] == "admin"

    # 2. 로그인된 유저의 권한 체크
    if user_signed_in? && (current_user.super_admin? || current_user.agency_owner? || current_user.agency_admin?)
      return
    end

    redirect_to new_admin_session_path, alert: "관리자 권한이 필요합니다."
  end
end
