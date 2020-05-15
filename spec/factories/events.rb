FactoryBot.define do
  factory :event do
    event_name { 'テスト勉強会' }
    event_content { 'テスト用の勉強会です。' }
    overview { 'これはテスト勉強会の概要です。' }
    event_capacity { 2 }
    start_at { '2020-05-31 19:00' }
    end_at { '2020-05-31 21:00' }
    necessities { '特にありません' }
    user
  end
end
