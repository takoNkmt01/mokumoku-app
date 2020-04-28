FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    username { 'テストユーザー' }
    profile { 'よろしくお願い致します。' }
    password { 'password' }
  end
end
