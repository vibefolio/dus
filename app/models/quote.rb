class Quote < ApplicationRecord
  validates :contact_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :message, presence: true
  validates :status, inclusion: { in: %w[pending completed] }
end
