# == Schema Information
#
# Table name: event_members
#
#  id         :bigint           not null, primary key
#  organizer  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_event_members_on_event_id              (event_id)
#  index_event_members_on_event_id_and_user_id  (event_id,user_id) UNIQUE
#  index_event_members_on_user_id               (user_id)
#
class EventMember < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :event_id, uniqueness: { scope: :user_id }

  scope :count_member, ->(target_event) { where(event_id: target_event.id, organizer: false) }

  # if event_member is greater than event_capacity → true
  def self.event_capacity_is_over?(event)
    self.count_event_members(event) == event.event_capacity
  end

  # count member who join the event except organizer
  def self.count_event_members(event)
    EventMember.count_member(event).count
  end
end
