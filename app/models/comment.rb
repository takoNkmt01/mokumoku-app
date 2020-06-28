# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  reply_to   :integer
#  text       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#  user_id    :integer          not null
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :text, presence: true

  scope :reply_comments, ->(target_comment) { where(reply_to: target_comment.id) }
  scope :event_comments, ->(target_event) { where(event_id: target_event.id) }
  scope :recent, -> { order(created_at: :desc) }

  # select returned comments
  def self.select_reply_comments(target_comment)
    Comment.reply_comments(target_comment)
  end

  # counts Reply to Comment
  def self.count_reply_comments(target_comment)
    self.select_reply_comments(target_comment).count
  end
end
