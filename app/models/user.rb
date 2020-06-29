# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  admin           :boolean          default(FALSE), not null
#  email           :string(255)      not null
#  full_name       :string(255)      not null
#  password_digest :string(255)      not null
#  profile         :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_one_attached :image
  has_many :events, dependent: :destroy
  has_many :event_members, dependent: :destroy
  has_many :events, through: :event_members
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarks_events, through: :bookmarks, source: :event
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification',
                                  foreign_key: 'visitor_id',
                                  dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification',
                                   foreign_key: 'visited_id',
                                   dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save { self.email = email.downcase }
  validates :full_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.].+[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 105 },
           uniqueness: { case_sensitive: false },
           format: { with: VALID_EMAIL_REGEX }
  has_secure_password

  def follow(target_user)
    following << target_user
  end

  def unfollow(target_user)
    active_relationships.find_by(followed_id: target_user.id).destroy
  end

  def following?(target_user)
    following.include?(target_user)
  end
end
