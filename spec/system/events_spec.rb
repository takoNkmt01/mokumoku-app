require 'rails_helper'

describe 'Event management', type: :system do
  let(:user_a) { FactoryBot.create(:user, username: 'ユーザーA', email: 'a@example.com') }
  let!(:user_b) { FactoryBot.create(:user, username: 'ユーザーB', email: 'b@example.com') }
  let!(:event_a) { FactoryBot.create(:event, event_name: '最初のイベント', overview: '検索ワードAを勉強します。', user: user_a) }
  let!(:access_map_a) { FactoryBot.create(:access_map, address: '新宿駅', event: event_a) }

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
    let(:login_user) { user_a }
    let!(:event_b) { FactoryBot.create(:event, event_name: 'サブイベント', overview: '検索ワードB', user: user_b) }
    let!(:access_map_b) { FactoryBot.create(:access_map, address: '新宿駅', event: event_b) }

    before do |example|
      if example.metadata[:navbar_form]
        find('.navbar-toggler-icon').click
        fill_in 'navSearchForm', with: search_param
        find('#navSearchButton').click
      end
    end

    before do |example|
      if example.metadata[:index_form]
        visit events_path
        fill_in 'indexSearchForm', with: search_param
        find('#indexSearchButton').click
      end
    end

    context 'with user_A signed in' do
      before do
        visit events_path
      end

      it_behaves_like 'shows event created by user_A'
    end

    context 'with search form with one word for overview column', :navbar_form do
      let(:search_param) { '検索ワードA' }

      it 'is valid that event_a is searchd' do
        expect(page).to have_content '"検索ワードA"を含むイベント'
        expect(page).to have_content '最初のイベント'
      end
    end

    context 'with search form with no word for event_name column', :navbar_form do
      let(:search_param) { '最初のイベント' }

      it 'is valid that user can searched with event_name' do
        expect(page).to have_content '"最初のイベント"を含むイベント'
        expect(page).to have_content '最初のイベント'
      end
    end

    context 'with search form with some words and blanks', :index_form do
      let(:search_param) { 'サブイベント 　検索ワードA 　　' }

      it 'shows that event_a and event_b was searched' do
        expect(page).to have_content '"サブイベント, 検索ワードA"を含むイベント'
        expect(page).to have_content '最初のイベント'
        expect(page).to have_content 'サブイベント'
      end
    end

    context 'with search form with ', :index_form do
      let(:search_param) { '' }

      it 'shows that blanks is ignored' do
        expect(page).to have_content 'イベント'
        expect(page).to have_content '最初のイベント'
        expect(page).to have_content 'サブイベント'
      end
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
      fill_in 'tag_name', with: skill_tags
      fill_in 'events_with_access_map_form[access_map_attributes][address]', with: address
      click_button '登録する'
    end

    context 'when all items was filled in' do
      let(:overview) { '全ての項目が記入されたケースです。' }
      let(:event_capacity) { 2 }
      let(:start_at) { '2020-08-31 19:00' }
      let(:end_at) { '2020-08-31 21:00' }
      let(:skill_tags) { '' }
      let(:address) { '新宿駅' }

      it 'was created successfully' do
        # selector
        expect(page).to have_selector '.alert-success', text: '新規イベントを登録しました'
      end
    end

    context 'when overview was blank' do
      let(:overview) { '' }
      let(:event_capacity) { 2 }
      let(:start_at) { '2020-08-31 19:00' }
      let(:end_at) { '2020-08-31 21:00' }
      let(:skill_tags) { '' }
      let(:address) { '新宿駅' }

      it 'failed to create event' do
        within '#error_explanation' do
          expect(page).to have_content '概要を入力してください'
        end
      end
    end

    context 'with tags is registered' do
      let(:overview) { '全ての項目が記入されたケースです。' }
      let(:event_capacity) { 2 }
      let(:start_at) { '2020-08-31 19:00' }
      let(:end_at) { '2020-08-31 21:00' }
      let(:skill_tags) { 'PHP Laravel' }
      let(:address) { '新宿駅' }

      before do
        visit events_path
      end

      it 'shows that tags was displayed at index' do
        expect(page).to have_content '#PHP'
        expect(page).to have_content '#Laravel'
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
      fill_in 'events_with_access_map_form[access_map_attributes][address]', with: '新宿駅'
    end

    context 'with user_A attending update own event' do
      let(:end_at) { '2020-08-31 20:00' }

      before do
        click_button '登録する'
      end

      it 'shows that event was updated successfully' do
        expect(page).to have_selector '.alert-success', text: 'イベント情報を更新しました'
      end
    end

    context 'with user_A failing to update event' do
      let(:end_at) { '2020-09-25 20:00' }

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

  describe 'Event Delete' do
    let(:login_user) { user_a }

    before do
      visit edit_event_path(event_a)
      click_link 'イベントを削除'
    end

    it 'shows that event was deleted successfully' do
      expect(page).to have_selector '.alert-danger', text: 'イベントを削除しました'
    end
  end
end
