class Admin::PartnersController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_partner, only: [:show, :edit, :update, :destroy]

  def index
    @partners = Partner.order(created_at: :desc)
  end

  def show
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      redirect_to admin_partners_path, notice: "파트너가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @partner.update(partner_params)
      redirect_to admin_partners_path, notice: "파트너 정보가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @partner.destroy
    redirect_to admin_partners_path, notice: "파트너가 삭제되었습니다."
  end

  private

  def set_partner
    @partner = Partner.find(params[:id])
  end

  def partner_params
    params.require(:partner).permit(
      :name, :email, :phone, :partner_type,
      :license_number, :company_name, :bio,
      :website_url, :active, :agency_id
    )
  end
end
