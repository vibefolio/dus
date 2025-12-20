class Admin::SessionsController < ApplicationController
  layout "clean" # 헤더/푸터 없는 깨끗한 레이아웃

  def new
    # 이미 로그인된 상태면 대시보드로 이동
    if session[:admin_id]
      redirect_to admin_root_path
    end
  end

  def create
    # Hardcoded credentials for simplicity (can be moved to DB later)
    admin_username = ENV.fetch("ADMIN_USERNAME", "admin@designd.co.kr")
    admin_password = ENV.fetch("ADMIN_PASSWORD", "djemals1234!")

    if params[:username] == admin_username && params[:password] == admin_password
      session[:admin_id] = "admin"
      redirect_to admin_root_path, notice: "관리자 모드로 접속했습니다."
    else
      flash.now[:alert] = "아이디 또는 비밀번호가 올바르지 않습니다."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to new_admin_session_path, notice: "로그아웃되었습니다."
  end
end
