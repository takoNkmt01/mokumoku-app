class User < ApplicationRecord
  has_many :events
  before_save { self.email = email.downcase }
  validates :username, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.].+[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 105 },
           uniqueness: { case_sensitive: false },
           format: { with: VALID_EMAIL_REGEX }
  has_secure_password
end
