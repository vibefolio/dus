class NativeController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /native/config
  def config
    render json: {
      app_name: "DUS",
      version: "1.0.0",
      tabs: [
        { title: "홈", path: "/", icon: "house" },
        { title: "템플릿", path: "/design_templates", icon: "grid" },
        { title: "포트폴리오", path: "/portfolio", icon: "briefcase" },
        { title: "마이페이지", path: "/mypage", icon: "person" }
      ],
      auth: {
        login_path: "/users/sign_in",
        signup_path: "/users/sign_up",
        logout_path: "/users/sign_out"
      },
      settings: {
        pull_to_refresh: true,
        show_toolbar: false,
        safe_area: true
      }
    }
  end
end
