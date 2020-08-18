require 'rails_helper'

describe 'Bookmark management', js: true, type: :system do
  let!(:test_user_a) { FactoryBot.create(:user, full_name: 'お気に入り太郎', email: 'bookmark@example.com') }
  let(:test_user_b) { FactoryBot.create(:user, full_name: 'お気に入り二郎', email: 'jiro@example.com') }
  let!(:test_event_a) { FactoryBot.create(:event, title: 'お気に入りイベント', user: test_user_a) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
    visit events_path
  end

  context 'with User click bookmark button' do
    let(:login_user) { test_user_b }

    it 'can register to bookmark' do
      find('.fa-star-o').click
      expect(page).to have_css "div#bookmark_btn_#{test_event_a.id}"
      expect(page).to have_css '.fa-star'
    end
  end

  context 'with User click unbookmark button' do
    let(:login_user) { test_user_b }

    it 'can remove bookmark' do
      find('.fa-star-o').click
      find('.fa-star').click
      expect(page).to have_css '.fa-star-o'
      expect(page).to have_css "div#bookmark_btn_#{test_event_a.id}"
    end
  end
end
