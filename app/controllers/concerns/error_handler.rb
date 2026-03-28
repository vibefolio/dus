module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable
  end

  private

  def not_found(exception)
    respond_to do |format|
      format.html { redirect_to root_path, alert: "요청하신 페이지를 찾을 수 없습니다." }
      format.json { render json: { error: "리소스를 찾을 수 없습니다." }, status: :not_found }
    end
  end

  def bad_request(exception)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: "잘못된 요청입니다: #{exception.message}" }
      format.json { render json: { error: "필수 파라미터 누락: #{exception.param}" }, status: :bad_request }
    end
  end

  def unprocessable(exception)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: exception.record.errors.full_messages.join(", ") }
      format.json { render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity }
    end
  end
end
