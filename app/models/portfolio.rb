class Portfolio < ApplicationRecord
  has_one_attached :image
  has_one_attached :mobile_image
  validates :title, presence: true
end
