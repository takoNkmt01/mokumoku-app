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
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with all items was filled in correctly' do
    it 'is valid with User' do
      user = User.new(
        email: 'sample@example.com',
        full_name: '例題太郎',
        profile: 'よろしくお願いします。',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to be_valid
    end
  end

  context 'with some item was not filled in' do
    it 'is not valid with User' do
      user = User.new(
        email: '',
        full_name: '例題太郎',
        profile: 'よろしくお願いします。',
        password: 'password',
        password_confirmation: 'password'
      )
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end
  end

  describe 'User follow feature' do
    before do
      @follower_user = FactoryBot.create(:user, full_name: 'フォロワー太郎', email: 'follower@example.com')
      @followed_user = FactoryBot.create(:user, full_name: 'フォロー二郎', email: 'followed@example.com')
    end

    it 'should follow user' do
      expect(@follower_user.following?(@followed_user)).to eq(false)
      @follower_user.follow(@followed_user)
      expect(@follower_user.following?(@followed_user)).to eq(true)
      expect(@followed_user.followers.include?(@follower_user)).to eq(true)
    end

    it 'should unfollowe user' do
      @follower_user.follow(@followed_user)
      expect(@follower_user.following?(@followed_user)).to eq(true)
      @follower_user.unfollow(@followed_user)
      expect(@follower_user.following?(@followed_user)).to eq(false)
    end
  end
end
