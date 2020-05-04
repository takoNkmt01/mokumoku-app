class Tag < ApplicationRecord
  has_many :event_tags
  has_many :events, through: :event_tags
  validates :name, presence: true, length: { minimum: 1, maximum: 25 }
  validates :name, uniqueness: true
end
