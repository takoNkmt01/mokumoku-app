require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with all items was filled in correctly' do
    it 'is valid with User' do
      user = User.new(
        email: 'sample@example.com',
        username: '例題太郎',
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
        username: '例題太郎',
        profile: 'よろしくお願いします。',
        password: 'password',
        password_confirmation: 'password'
      )
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end
  end
end
