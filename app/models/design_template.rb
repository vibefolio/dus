class DesignTemplate < ApplicationRecord
  has_one_attached :pc_image
  has_one_attached :mobile_image

  validates :title, presence: true
end
