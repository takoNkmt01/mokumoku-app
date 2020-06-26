# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  scope :select_with_id, ->(some_id) { where(id: some_id) }
  scope :recent, -> { order(updated_at: :desc) }
end
