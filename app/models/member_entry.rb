# == Schema Information
#
# Table name: member_entries
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
#  index_member_entries_on_event_id              (event_id)
#  index_member_entries_on_event_id_and_user_id  (event_id,user_id) UNIQUE
#  index_member_entries_on_user_id               (user_id)
#
class MemberEntry < ApplicationRecord
  belongs_to :event
  belongs_to :user
  has_many :notification, dependent: :destroy

  validates :event_id, uniqueness: { scope: :user_id }

  scope :count_member, ->(target_event) { where(event_id: target_event.id, organizer: false) }

  # if member_entry is greater than capacity → true
  def self.capacity_is_over?(event)
    self.count_member_entries(event) == event.capacity
  end

  # count member who join the event except organizer
  def self.count_member_entries(event)
    MemberEntry.count_member(event).count
  end

  def create_notification_member_entry!(current_user)
    temp = notification.where(
      ['visitor_id = ? and visited_id = ? and member_entry_id = ? and action = ?',
       current_user.id, event.user.id, id, 'event_member']
    )
    return unless temp.blank?

    notification = current_user.active_notifications.new(
      visited_id: event.user.id,
      member_entry_id: id,
      action: 'event_member'
    )
    notification.save if notification.valid?
  end
end
