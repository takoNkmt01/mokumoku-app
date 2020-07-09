require 'rails_helper'

describe 'MemberEntryManagement', js: true, type: :system do
  let(:user_a) { FactoryBot.create(:user, full_name: '参加者A', email: 'org@example.com') }
  let!(:user_b) { FactoryBot.create(:user, full_name: '主催者', email: 'user-b@example.com') }
  let!(:user_c) { FactoryBot.create(:user, full_name: '参加者B', email: 'senkyaku@example.com') }
  let!(:event) { FactoryBot.create(:event, title: '参加可能なイベント', capacity: 1, user: user_b) }
  let!(:access_map) { FactoryBot.create(:access_map, address: '新宿駅', event: event) }

  before do |example|
    unless example.metadata[:skip_login]
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログイン'
    end
  end

  describe 'Organizer create new event' do
    let(:login_user) { user_a }

    before do
      visit new_event_path
      fill_in 'イベント名', with: '新規作成イベント'
      fill_in 'イベント内容', with: '新規作成のテストです。'
      fill_in 'イベント概要', with: overview
      fill_in '参加者定員', with: capacity
      fill_in '開始日時', with: start_at
      fill_in '終了日時', with: end_at
      fill_in '必要なもの', with: '本テストケースが通ること'
      fill_in 'tag_name', with: skill_tags
      fill_in 'events_with_access_map_form[access_map_attributes][address]', with: address
      click_button '登録する'
      click_link '開催イベント'
    end

    context 'with Organizer could create new event' do
      let(:overview) { '全ての項目が記入されたケースです。' }
      let(:capacity) { 2 }
      let(:start_at) { '2020-07-31 19:00' }
      let(:end_at) { '2020-07-31 21:00' }
      let(:skill_tags) { '' }
      let(:address) { '新宿駅' }

      it 'shows that new event is displayed' do
        expect(page).to have_content '新規作成イベント'
      end
    end
  end

  describe 'User attend to join the event above' do
    let(:login_user) { user_a }

    before do
      visit event_path(event)
      find('input[type="submit"]').click
    end

    before do |example|
      if example.metadata[:special_before]
        visit user_path(user_a)
        click_link '参加イベント'
      end
    end

    context 'with No loggedin User attend to join the event' do
      it 'shows that skip to login page and message', :skip_login do
        expect(page).to have_selector '.alert-success', text: 'イベントに参加するにはログインが必要です'
      end
    end

    context 'with UserA can join the event' do
      it 'shows that UserA could join the event' do
        expect(page).to have_selector '.alert-success', text: 'イベント参加の申し込みが完了しました'
      end

      it 'shows that event which is joined by UserA is displayed', :special_before do
        expect(page).to have_content '参加可能なイベント'
      end
    end

    context 'with UserC cannot join the event' do
      before do
        visit login_path
        fill_in 'メールアドレス', with: 'senkyaku@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        visit event_path(event)
      end

      it 'shows that join button is disabled' do
        expect(find('#event_join')).to be_disabled
      end
    end
  end
end
