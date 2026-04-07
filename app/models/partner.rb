class Partner < ApplicationRecord
  belongs_to :agency, optional: true
  has_many :orders, foreign_key: :partner_id

  TYPES = {
    "tax"    => "세무사",
    "legal"  => "법무사",
    "design" => "디자이너"
  }.freeze

  validates :name, :email, :partner_type, presence: true
  validates :email, uniqueness: true
  validates :partner_type, inclusion: { in: TYPES.keys }

  scope :active, -> { where(active: true) }
  scope :tax,    -> { where(partner_type: "tax") }

  def type_label
    TYPES[partner_type] || partner_type
  end
end
