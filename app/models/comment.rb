class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :text, presence: true

  scope :reply_count, ->(target_comment) { where(reply_to: target_comment.id) }

  # select returned comments
  def self.select_returned_comments(target_comment)
    Comment.reply_count(target_comment)
  end
end
