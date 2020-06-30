require 'rails_helper'

describe 'Notification management', type: :system do
  let!(:user_a) { FactoryBot.create(:user, full_name: '送り主太郎', email: 'send-to@example.com') }
  let!(:user_b) { FactoryBot.create(:user, full_name: '受取り太郎', email: 'acception@example.com') }
  let!(:event_b) { FactoryBot.create(:event, title: 'テストイベント', user: user_b) }
  let!(:map_b) { FactoryBot.create(:access_map, event: event_b) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  shared_context 'second login by user_b' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: 'acception@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end
  end

  describe 'Event Bookmark feature' do
    let(:login_user) { user_a }

    before do
      visit events_path
      find('.fa-star-o').click
    end

    context 'user_a bookmarks the event hosted by user_b' do
      include_context 'second login by user_b'

      it 'is displayed notification about bookmarked own event' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '送り主太郎さんがあなたの主催イベントをブックマーク登録しました'
        expect(page).to have_content 'New'
      end
    end

    context 'user_b re-access notifications page' do
      include_context 'second login by user_b'

      before do
        visit user_notifications_path(user_b)
        visit events_path
      end
      it 'should not display New tag for notification' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '送り主太郎さんがあなたの主催イベントをブックマーク登録しました'
        expect(page).to have_no_content 'New'
      end
    end
  end

  describe 'Event Comment feature' do
    let(:login_user) { user_a }

    before do
      visit event_path(event_b)
      find('.fa-comment').click
      fill_in 'comment_text', with: 'テストコメント'
      click_button '送信する'
    end

    context 'user_a comments to the event hosted by user_b' do
      include_context 'second login by user_b'

      it 'is displayed notification about the comment' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '送り主太郎さんがあなたの主催イベントにコメントしました'
        expect(page).to have_content 'テストコメント'
      end
    end
  end

  describe 'Message to other user' do
    let(:login_user) { user_a }

    before do
      visit user_path(user_b)
      find('#hasNoRoom').click
      fill_in 'message_body', with: 'テストメッセージを送ります。'
      click_button '送信する'
    end

    context 'user_a send message to user_b' do
      include_context 'second login by user_b'

      it 'is displayed notification about the message' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '送り主太郎さんがあなたにメッセージを送っています'
        expect(page).to have_content 'テストメッセージを送ります。'
      end
    end
  end

  describe 'Follow an user' do
    let(:login_user) { user_a }

    before do
      visit user_path(user_b)
      click_button 'フォローする'
    end

    context 'with user_a follow user_b' do
      include_context 'second login by user_b'

      it 'is displayed notification about follow from other user' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '送り主太郎さんがあなたをフォローしました'
        expect(page).to have_content 'New'
      end
    end

    context 'with user_a unfollow user_b after following' do
      before do
        click_button 'フォロー解除'
      end
      include_context 'second login by user_b'

      it 'is not displayed notification about follow from other user' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '通知はありません'
      end
    end
  end

  describe 'MemberEntry for Event' do
    let(:login_user) { user_a }

    before do
      visit event_path(event_b)
      find('input[type="submit"]').click
    end

    context 'with user_a participate in the event hosted by user_b' do
      include_context 'second login by user_b'

      it 'should display notification about member_entry' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '送り主太郎さんがあなたの主催イベントへの参加申し込みを行いました'
      end
    end

    context 'with user_a cancel to participant for event hosted by user_b', js: true do
      before do
        page.accept_confirm do
          find('.btn-warning').click
        end
        visit events_path
      end
      include_context 'second login by user_b'

      it 'should not display notification about member_entry' do
        visit user_notifications_path(user_b)
        expect(page).to have_content '通知はありません'
      end
    end
  end
end
