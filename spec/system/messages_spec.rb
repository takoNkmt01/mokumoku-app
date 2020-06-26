require 'rails_helper'

describe 'Messages management', type: :system do
  let!(:user_a) { FactoryBot.create(:user, full_name: 'チャット相手太郎', email: 'chat_target@example.com') }
  let(:user_b) { FactoryBot.create(:user, full_name: 'チャット送信一郎', email: 'ichiro@example.com') }

  before do |example|
    if example.metadata[:need_to_login]
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end
  end

  describe 'Message room has already created', :need_to_login do
    let(:login_user) { user_b }

    before do
      visit user_path(user_a)
      find('#hasNoRoom').click
    end

    context 'with user_b send message to user_a' do
      it 'is able to send message with Ajax', js: true do
        fill_in 'message_body', with: '最初のメッセージ。テストです。'
        click_button '送信する'
        expect(page).to have_content '最初のメッセージ。テストです。'
      end
    end

    describe 'User B has already send message to User A', :need_to_login do
      let(:login_user) { user_b }

      before do
        visit user_path(user_a)
        find('#hasRoom').click
        fill_in 'message_body', with: 'テストメッセージを送信しました。'
        click_button '送信する'
      end

      context 'with user_a access to message rooms page' do
        before do
          visit login_path
          fill_in 'メールアドレス', with: 'chat_target@example.com'
          fill_in 'パスワード', with: 'password'
          click_button 'ログイン'
          visit user_rooms_path(user_a)
        end

        it 'is display message which user_b sent' do
          expect(page).to have_content 'テストメッセージを送信しました。'
        end
      end

      context 'with user_b deleted sent message' do
        it 'is deleted message from room', js: true do
          Capybara.current_window.resize_to(1280, 1000)
          page.accept_confirm do
            find('.fa-trash').click
          end
          expect(page).to have_no_content 'テストメッセージを送信しました。'
        end
      end
    end
  end
end
