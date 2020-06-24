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

  before_save { self.email = email.downcase }
  validates :full_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.].+[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 105 },
           uniqueness: { case_sensitive: false },
           format: { with: VALID_EMAIL_REGEX }
  has_secure_password
end
