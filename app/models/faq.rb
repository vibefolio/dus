class Faq < ApplicationRecord
  # Validations
  validates :question, presence: true
  validates :answer, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc, created_at: :asc) }

  # Default scope
  default_scope { ordered }

  # Callbacks
  before_validation :set_default_position, on: :create

  private

  def set_default_position
    self.position ||= (Faq.maximum(:position) || 0) + 1
  end
end
