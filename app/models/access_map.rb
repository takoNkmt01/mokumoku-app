# == Schema Information
#
# Table name: access_maps
#
#  id         :bigint           not null, primary key
#  address    :string(255)      not null
#  latitude   :float(24)
#  longitude  :float(24)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#
class AccessMap < ApplicationRecord
  belongs_to :event, optional: true
  geocoded_by :address
  after_validation :geocode
  validates :address, presence: true
end
