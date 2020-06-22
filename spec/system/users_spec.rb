require 'rails_helper'

describe 'User management', type: :system do
  let!(:test_user) { FactoryBot.create(:user) }
  let!(:test_event) { FactoryBot.create(:event, title: 'テストイベント', user: test_user) }
  let(:test_user3) { FactoryBot.create(:user, full_name: 'テストユーザー3', email: 'test3@example.com') }

  before do |example|
    if example.metadata[:need_to_login]
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end
  end

  shared_examples_for 'shows that access denied' do
    it { expect(page).to have_selector '.alert-danger', text: '不正なアクセスです' }
  end

  describe 'index action' do
    before do
      visit users_path
    end

    context 'with test_user was registered' do
      it 'shows that test_user is displayed at index page' do
        expect(page).to have_content 'テストユーザー'
      end
    end
  end

  describe 'create action' do
    before do
      visit signup_path
      fill_in '氏名', with: 'テストユーザー2'
      fill_in 'メールアドレス', with: 'test2@example.com'
      fill_in 'パスワード', with: password
      fill_in 'パスワード(確認用)', with: password_confirmation
      fill_in 'プロフィール', with: 'よろしくお願い致します'
      click_button '登録する'
    end

    context 'with all items was filled correctly' do
      let(:password) { 'password' }
      let(:password_confirmation) { 'password' }

      it 'shows that user registration was success' do
        expect(page).to have_selector '.alert-success', text: 'ユーザー登録が完了しました'
      end
    end

    context 'with password and password_confirmation was not same value' do
      let(:password) { 'password' }
      let(:password_confirmation) { 'asdfdiuo' }

      it 'failed to registrate new user' do
        within '#error_explanation' do
          expect(page).to have_content 'パスワード(確認用)とパスワードの入力が一致しません'
        end
      end
    end
  end

  describe 'show action' do
    before do
      visit user_path(test_user)
    end

    it 'shows that no login user can access test_user page' do
      expect(page).to have_content 'テストユーザー'
    end
  end

  describe 'edit action' do
    before do
      visit edit_user_path(test_user)
    end

    context 'with accessing edit page in person', :need_to_login do
      let(:login_user) { test_user }

      it 'shows that test user can access own edit page' do
        expect(page).to have_content 'テストユーザーさん'
      end
    end

    context 'with no login user attend to access test_user edit page' do
      it_behaves_like 'shows that access denied'
    end

    context 'with other login user attend to access test_user edi page' do
      let(:login_user) { test_user3 }

      it_behaves_like 'shows that access denied', :need_to_login
    end
  end

  describe 'update action', :need_to_login do
    let(:login_user) { test_user }

    before do
      visit edit_user_path(test_user)
      fill_in '氏名', with: 'テストユーザー2'
      fill_in 'メールアドレス', with: 'test2@example.com'
      fill_in 'パスワード', with: password
      fill_in 'パスワード(確認用)', with: password_confirmation
      fill_in 'プロフィール', with: 'よろしくお願い致します'
      click_button '更新する'
    end

    context 'with test user update own information' do
      let(:password) { '' }
      let(:password_confirmation) { '' }

      it 'shows that updated successfully' do
        expect(page).to have_content 'ユーザー情報を更新しました'
      end
    end
  end

  describe 'User delstroy' do
    let(:login_user) { test_user }

    before do
      visit edit_user_path(test_user)
      page.accept_confirm do
        click_link '退会する'
      end
    end

    it 'show that user was deleted successfully', :need_to_login do
      expect(page).to have_selector '.alert-danger', text: 'ご利用ありがとうございました。またのご利用をお待ちしております。'
    end
  end

  describe 'BookMark show feature' do
    let(:login_user) { test_user3 }

    context 'with User has one bookmark', :need_to_login do
      before do
        visit events_path
        find('.fa-star-o').click
        visit user_bookmarks_path(test_user3)
      end

      it 'shows that bookmark events is displayed' do
        expect(page).to have_content 'テストイベント'
      end
    end
  end
end
