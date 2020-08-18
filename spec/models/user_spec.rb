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
    it 'is valid with all item was filled in' do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it 'is not valid with some items was blunk' do
      user = FactoryBot.build(:user, email: '')
      expect(user).not_to be_valid
    end
  end

  context 'with email check' do
    it 'is work about invalid check for email with regex' do
      expect(FactoryBot.build(:user, email: 'aexample')).not_to be_valid
      expect(FactoryBot.build(:user, email: 'あ@example')).not_to be_valid
    end

    it 'valid about max lenght of email' do
      expect(FactoryBot.build(:user, email: 'a' * 50 + '@' + 'a' * 54)).to be_valid
    end

    it 'is work about the check about email max length' do
      expect(FactoryBot.build(:user, email: 'a' * 50 + '@' + 'a' * 55)).not_to be_valid
    end
  end

  context 'with unique validation' do
    it 'is work about invalid check for uniqueness' do
      user = FactoryBot.build(:user)
      duplicate_user = user.dup
      user.save!
      expect(duplicate_user).not_to be_valid
    end
  end

  context 'User follow feature' do
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
