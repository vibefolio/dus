class OrderPolicy < ApplicationPolicy
  def show?
    owner? || admin?
  end

  def update?
    admin?
  end

  def cancel?
    owner? && record.pending?
  end
end
