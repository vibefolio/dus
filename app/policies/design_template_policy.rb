class DesignTemplatePolicy < ApplicationPolicy
  def index?
    true  # 모든 사용자 열람 가능
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    user&.super_admin?
  end
end
