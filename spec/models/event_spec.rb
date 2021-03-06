# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  capacity    :integer          not null
#  content     :string(255)      not null
#  end_at      :datetime         not null
#  necessities :string(255)      default("必要なものはありません!")
#  overview    :text(65535)      not null
#  start_at    :datetime         not null
#  title       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
require 'rails_helper'

RSpec.describe Event, type: :model do
  let!(:user_a) { FactoryBot.create(:user) }

  context 'with all items was filled in correctly' do
    it 'is valid with Event' do
      event = user_a.events.new(
        title: '初めてのイベント',
        content: '初めてのイベントです',
        overview: '初めてのイベントの参加お待ちしております',
        capacity: 2,
        start_at: '2020-09-30 19:00',
        end_at: '2020-09-30 21:00',
        user_id: user_a.id
      )
      expect(event).to be_valid
    end
  end

  context 'with some items was not filled in' do
    it 'is not valid with Event' do
      event = user_a.events.new(
        title: nil,
        content: '初めてのイベントです',
        overview: '初めてのイベントの参加お待ちしております',
        capacity: 2,
        start_at: '2020-09-30 19:00',
        end_at: '2020-09-30 21:00',
        user_id: user_a.id
      )
      event.valid?
      expect(event.errors[:title]).to include('を入力してください')
    end
  end

  describe 'Event Date' do
    context 'with user choices date before today' do
      it 'is not valid with start_at before today' do
        event = user_a.events.new(
          title: '初めてのイベント',
          content: '初めてのイベントです',
          overview: '初めてのイベントの参加お待ちしております',
          capacity: 2,
          start_at: '2020-05-15 19:00',
          end_at: '2020-05-15 21:00',
          user_id: user_a.id
        )
        event.valid?
        expect(event.errors[:start_at]).to include('は本日以降を選択して下さい')
      end
    end

    context 'with user choices end_at which is different form start_at' do
      it 'is not valid with end_at' do
        event = user_a.events.new(
          title: '初めてのイベント',
          content: '初めてのイベントです',
          overview: '初めてのイベントの参加お待ちしております',
          capacity: 2,
          start_at: '2020-09-30 19:00',
          end_at: '2020-10-02 21:00',
          user_id: user_a.id
        )
        event.valid?
        expect(event.errors[:end_at]).to include('は開始日時と同じ日付を選択して下さい')
      end
    end
  end
end
