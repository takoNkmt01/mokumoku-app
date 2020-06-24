# == Schema Information
#
# Table name: entries
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_entries_on_room_id  (room_id)
#  index_entries_on_user_id  (user_id)
#
class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room

  scope :recent, -> { order(updated_at: :desc) }
  scope :select_target_user_entry,
        ->(entry) { where(room_id: entry.room_id).where.not(user_id: entry.user_id) }

  def self.acquire_room_id_if_exists(loggedin_user_id, target_user_id)
    current_user_entry = Entry.where(user_id: loggedin_user_id)
    target_user_entry = Entry.where(user_id: target_user_id)

    room_id = nil
    current_user_entry.each do |cue|
      target_user_entry.each do |tue|
        room_id = cue.room_id if cue.room_id == tue.room_id
      end
    end
    room_id
  end

  def self.target_user_entry(current_user_entry)
    target_user_entry = Entry.none
    current_user_entry.each do |entry|
      target_user_entry = target_user_entry.or(Entry.select_target_user_entry(entry))
    end
    target_user_entry.recent
  end
end
