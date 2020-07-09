require 'rails_helper'

describe 'Relationship management', js: true, type: :system do
  let!(:user_a) { FactoryBot.create(:user, full_name: 'フォロワー太郎', email: 'follower@example.com') }
  let!(:user_b) { FactoryBot.create(:user, full_name: 'フォロー二郎', email: 'following@example.com') }

  before do |example|
    unless example.metadata[:need_not_to_login]
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end
  end

  context 'with no login user attempt to follow some user', :need_not_to_login do
    before do
      visit user_path(user_a)
    end

    it 'can not click the follow button' do
      expect(find('#followButton')).to be_disabled
    end
  end

  context 'with login user follow some user' do
    let(:login_user) { user_b }

    before do
      visit user_path(user_a)
    end

    it 'should follow a user' do
      click_button 'フォローする'
      expect(page).to have_button 'フォロー解除'
      expect(page).to have_content 'フォロワー 1'
    end

    it 'should unfollow a user' do
      click_button 'フォローする'
      expect(page).to have_content 'フォロワー 1'
      click_button 'フォロー解除'
      expect(page).to have_button 'フォローする'
      expect(page).to have_content 'フォロワー 0'
    end
  end
end
