# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    follower_user = FactoryBot.create(:user, full_name: 'フォロワー太郎', email: 'follower@example.com')
    followed_user = FactoryBot.create(:user, full_name: 'フォロー二郎', email: 'followed@example.com')
    @relationship = Relationship.new(follower_id: follower_user.id, followed_id: followed_user.id)
  end

  it 'should be valid' do
    expect(@relationship).to be_valid
  end

  it 'should require a follower_id' do
    @relationship.follower_id = nil
    @relationship.valid?
    expect(@relationship.errors[:follower_id]).to include('を入力してください')
  end

  it 'should require a followed_id' do
    @relationship.followed_id = nil
    @relationship.valid?
    expect(@relationship.errors[:followed_id]).to include('を入力してください')
  end
end
