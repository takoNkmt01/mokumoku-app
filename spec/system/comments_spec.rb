require 'rails_helper'

describe 'Comments management', type: :system do
  let!(:test_user) { FactoryBot.create(:user, full_name: 'テスト太郎', email: 'test@example.com') }
  let(:comment_user) { FactoryBot.create(:user, full_name: 'コメント太郎', email: 'comment@example.com') }
  let(:reply_user) { FactoryBot.create(:user, full_name: '返信太郎', email: 'reply@example.com') }
  let!(:test_event) { FactoryBot.create(:event, title: 'テストイベント', user: test_user) }
  let!(:test_event_2) { FactoryBot.create(:event, title: 'テストイベント２', user: test_user) }
  let!(:test_map) { FactoryBot.create(:access_map, address: '新宿駅', event: test_event) }
  let!(:test_map2) { FactoryBot.create(:access_map, address: '新宿駅', event: test_event_2) }
  let!(:initial_comment) { FactoryBot.create(:comment, text: 'Rspec用コメント', event: test_event, user: test_user) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  context 'with User post a comment' do
    let(:login_user) { comment_user }

    before do
      visit event_path(test_event)
    end

    it 'shows that comment was posted' do
      find('.fa-comment').click
      fill_in 'comment_text', with: 'テストコメント'
      click_button '送信する'
      expect(page).to have_content 'テストコメント'
    end
  end

  context 'with User delete own comment', js: true do
    let(:login_user) { comment_user }

    before do
      visit event_path(test_event)
    end

    it 'shows that User can delete own comment' do
      find('.fa-comment').click
      fill_in 'comment_text', with: 'テストコメント'
      click_button '送信する'
      expect(page).to have_css '.fa-trash'
      page.accept_confirm do
        find('.fa-trash').click
      end
      expect(page).to have_no_content 'テストコメント'
    end
  end

  context 'with other User post a reply comment' do
    let(:login_user) { reply_user }

    before do
      visit event_path(test_event)
    end

    it 'shows that User can post a reply comment' do
      find('.fa-reply').click
      fill_in 'commentBody', with: '返信テストコメント'
      click_button '送信する'
      expect(page).to have_content '1件の返信'
      click_link '1件の返信'
      expect(page).to have_content '返信テストコメント'
    end
  end

  context 'with other User delete own reply comment', js: true do
    let(:login_user) { reply_user }

    before do
      visit event_path(test_event)
    end

    it 'show that other user can delete own reply comment' do
      find('.fa-reply').click
      fill_in 'commentBody', with: '返信テストコメント'
      click_button '送信する'
      click_link '1件の返信'
      expect(page).to have_css '.fa-trash'
      page.accept_confirm do
        find('.fa-trash').click
      end
      expect(page).to have_no_css '.fa-trash'
    end
  end
end
