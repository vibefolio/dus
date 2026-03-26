class QuotePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || owner?
  end

  def update?
    admin?
  end

  def destroy?
    user&.super_admin?
  end
end
