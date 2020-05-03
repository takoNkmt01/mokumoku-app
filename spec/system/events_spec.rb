require 'rails_helper'

describe 'Event management', type: :system do
  let(:user_a) { FactoryBot.create(:user, username: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, username: 'ユーザーB', email: 'b@example.com') }
  let!(:event_a) { FactoryBot.create(:event, event_name: '最初のイベント', user: user_a) }
  let!(:map_a) { FactoryBot.create(:map, address: '新宿駅', event: event_a) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  # itケースの共通化
  shared_examples_for 'shows event created by user_A' do
    it { expect(page).to have_content '最初のイベント' }
  end

  # EventsController#index
  describe 'events list feature' do
    context 'with user_A signed in' do
      let(:login_user) { user_a }

      before do
        visit events_path
      end

      it_behaves_like 'shows event created by user_A'
    end
  end

  # EventsController#create
  describe 'create new event feature' do
    let(:login_user) { user_a }

    before do
      visit new_event_path
      fill_in 'イベント名', with: '新規作成イベント'
      fill_in 'イベント内容', with: '新規作成のテストです。'
      fill_in 'イベント概要', with: overview
      fill_in '参加者定員', with: event_capacity
      fill_in '開始日時', with: start_at
      fill_in '終了日時', with: end_at
      fill_in '必要なもの', with: '本テストケースが通ること'
      fill_in 'events_with_map_form[map_attributes][address]', with: address
      click_button '登録する'
    end

    context 'when all items was filled in' do
      let(:overview) { '全ての項目が記入されたケースです。' }
      let(:event_capacity) { 2 }
      let(:start_at) { '2020-05-05 19:00' }
      let(:end_at) { '2020-05-05 21:00' }
      let(:address) { '新宿駅' }

      it 'created successfully' do
        # selector
        expect(page).to have_selector '.alert-success', text: '新規イベントを登録しました'
      end
    end

    context 'when overview was blank' do
      let(:overview) { '' }
      let(:event_capacity) { 2 }
      let(:start_at) { '2020-04-28 19:00' }
      let(:end_at) { '2020-04-28 21:00' }
      let(:address) { '新宿駅' }

      it 'failed to create event' do
        within '#error_explanation' do
          expect(page).to have_content '概要を入力してください'
        end
      end
    end
  end

  # EventsController#show
  describe 'event detail show feature' do
    context 'with user_A signed in' do
      let(:login_user) { user_a }

      before do
        visit event_path(event_a)
      end

      it_behaves_like 'shows event created by user_A'
    end
  end

  # EventsController#edit
  describe 'edit event feature' do
    before do
      visit edit_event_path(which_event)
    end

    context 'with user_A attendint to edit own event' do
      let(:login_user) { user_a }
      let(:which_event) { event_a }

      it 'shows that user_A can access own event edit page' do
        expect(page).to have_content 'イベント編集'
      end
    end

    context 'with user_B attending to edit event created by user_A' do
      let(:login_user) { user_b }
      let(:which_event) { event_a }

      it 'shows that redirecting user_path and error message' do
        expect(page).to have_no_content '最初のイベント'
        expect(page).to have_selector '.alert-danger', text: '不正なアクセスです'
      end
    end
  end

  # EventsController#update
  describe 'update event' do
    let(:login_user) { user_a }
    let(:event_content) { 'イベント内容の更新' }

    before do
      visit edit_event_path(event_a)
      fill_in 'イベント内容', with: event_content
      fill_in '終了日時', with: end_at
      fill_in 'events_with_map_form[map_attributes][address]', with: '新宿駅'
    end

    context 'with user_A attending update own event' do
      let(:end_at) { '2020-05-05 20:00' }

      before do
        click_button '登録する'
      end

      it 'shows that event was updated successfully' do
        expect(page).to have_selector '.alert-success', text: 'イベント情報を更新しました'
      end
    end

    context 'with user_A failing to update event' do
      let(:end_at) { '2020-05-02 20:00' }

      before do
        click_button '登録する'
      end

      it 'shows that update is failed' do
        within '#error_explanation' do
          expect(page).to have_content '終了日時は開始日時と同じ日付を選択して下さい'
        end
      end
    end
  end
end
