class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :text, presence: true

  scope :reply_comments, ->(target_comment) { where(reply_to: target_comment.id) }

  # select returned comments
  def self.select_reply_comments(target_comment)
    Comment.reply_comments(target_comment)
  end

  # counts Reply to Comment
  def self.count_reply_comments(target_comment)
    self.select_reply_comments(target_comment).count
  end
end
