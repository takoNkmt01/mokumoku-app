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
FactoryBot.define do
  factory :access_map do
    address { '新宿駅' }
  end
end
