require 'rails_helper'

describe 'Rooms management', type: :system do
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

  context 'with loggedin user attempt to create new message room', :need_to_login do
    let(:login_user) { user_b }

    before do
      visit user_path(user_a)
      find('#hasNoRoom').click
    end

    it 'is able to create message room' do
      expect(page).to have_content 'チャット相手太郎さんにメッセージを送る'
    end

    it 'is displayed created message room at room.html' do
      visit user_rooms_path(user_b)
      expect(page).to have_content 'チャット相手太郎'
    end

    context 'with loggedin user attempt to create message room with same user' do
      before do
        visit user_path(user_a)
      end

      it 'should transit to message room which was already created' do
        find('#hasRoom').click
        expect(page).to have_content 'チャット相手太郎さんにメッセージを送る'
      end
    end
  end

  context 'with no loggedin user attempt to create message room' do
    before do
      visit user_path(user_a)
    end

    it 'should not display button for creating message room' do
      expect(page).to have_no_button 'メッセージを送る'
    end
  end
end
