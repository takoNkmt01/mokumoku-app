class Event < ApplicationRecord
  belongs_to :user
  validates :event_name, presence: true
  validates :event_content, presence: true
  validates :start_time, presence: true
  validates :user_id, presence: true
end
