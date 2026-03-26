module TurboNativeApp
  extend ActiveSupport::Concern

  included do
    helper_method :turbo_native_app?
  end

  def turbo_native_app?
    request.user_agent.to_s.match?(/Turbo Native/)
  end

  # 네이티브 앱에서는 레이아웃을 간소화 (navbar/footer 숨김)
  def set_native_layout
    "mobile" if turbo_native_app?
  end
end
