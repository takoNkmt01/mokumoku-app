# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  admin           :boolean          default(FALSE), not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  profile         :string(255)
#  username        :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    username { 'テストユーザー' }
    profile { 'よろしくお願い致します。' }
    password { 'password' }
  end
end
