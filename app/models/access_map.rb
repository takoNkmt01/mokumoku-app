class AccessMap < ApplicationRecord
  belongs_to :event, optional: true
  geocoded_by :address
  after_validation :geocode
  validates :address, presence: true
end
