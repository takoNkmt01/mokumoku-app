require 'rails_helper'

describe 'Tags Management', type: :system do
  let(:user_a) { FactoryBot.create(:user, full_name: 'タグ用ユーザー') }

  before do
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログイン'
  end

  describe 'Tag show' do
    let(:login_user) { user_a }

    before do
      visit new_event_path
      fill_in 'イベント名', with: 'タグ用新規作成イベント'
      fill_in 'イベント内容', with: '新規作成のテストです。'
      fill_in 'イベント概要', with: overview
      fill_in '参加者定員', with: 2
      fill_in '開始日時', with: '2020-08-31 15:00'
      fill_in '終了日時', with: '2020-08-31 17:00'
      fill_in '必要なもの', with: '本テストケースが通ること'
      fill_in 'tag_name', with: skill_tags
      fill_in 'events_with_access_map_form[access_map_attributes][address]', with: '新宿駅'
      click_button '登録する'
    end

    context 'with user search clicking tag' do
      let(:overview) { 'タグテスト用のイベントです。' }
      let(:skill_tags) { 'PHP Laravel' }

      before do
        visit events_path
        click_link '#PHP'
      end

      it 'shows that event which is related tag is displayed' do
        expect(page).to have_content '"#PHP"を含むイベント'
        expect(page).to have_content 'タグ用新規作成イベント'
      end
    end
  end
end
