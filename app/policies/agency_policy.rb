class AgencyPolicy < ApplicationPolicy
  def show?
    member? || admin?
  end

  def update?
    agency_owner? || user&.super_admin?
  end

  def destroy?
    user&.super_admin?
  end

  private

  def member?
    user&.agency_id == record.id
  end

  def agency_owner?
    record.owner_id == user&.id
  end
end
