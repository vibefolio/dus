class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def admin?
    user&.super_admin? || user&.agency_owner? || user&.agency_admin?
  end

  def owner?
    record.respond_to?(:user_id) && record.user_id == user&.id
  end
end
