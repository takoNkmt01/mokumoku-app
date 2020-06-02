require 'rails_helper'

RSpec.describe Event, type: :model do
  let!(:user_a) { FactoryBot.create(:user) }

  context 'with all items was filled in correctly' do
    it 'is valid with Event' do
      event = user_a.events.new(
        event_name: '初めてのイベント',
        event_content: '初めてのイベントです',
        overview: '初めてのイベントの参加お待ちしております',
        event_capacity: 2,
        start_at: '2020-07-31 19:00',
        end_at: '2020-07-31 21:00',
        user_id: user_a.id
      )
      expect(event).to be_valid
    end
  end

  context 'with some items was not filled in' do
    it 'is not valid with Event' do
      event = user_a.events.new(
        event_name: nil,
        event_content: '初めてのイベントです',
        overview: '初めてのイベントの参加お待ちしております',
        event_capacity: 2,
        start_at: '2020-07-31 19:00',
        end_at: '2020-07-31 21:00',
        user_id: user_a.id
      )
      event.valid?
      expect(event.errors[:event_name]).to include('を入力してください')
    end
  end

  describe 'Event Date' do
    context 'with user choices date before today' do
      it 'is not valid with start_at before today' do
        event = user_a.events.new(
          event_name: '初めてのイベント',
          event_content: '初めてのイベントです',
          overview: '初めてのイベントの参加お待ちしております',
          event_capacity: 2,
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
          event_name: '初めてのイベント',
          event_content: '初めてのイベントです',
          overview: '初めてのイベントの参加お待ちしております',
          event_capacity: 2,
          start_at: '2020-07-31 19:00',
          end_at: '2020-08-02 21:00',
          user_id: user_a.id
        )
        event.valid?
        expect(event.errors[:end_at]).to include('は開始日時と同じ日付を選択して下さい')
      end
    end
  end
end
