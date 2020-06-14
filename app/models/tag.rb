# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
class Tag < ApplicationRecord
  has_many :event_tags
  has_many :events, through: :event_tags
  validates :name, presence: true, length: { minimum: 1, maximum: 25 }
  validates :name, uniqueness: true
end
