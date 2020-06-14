# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  end_at         :datetime         not null
#  event_capacity :integer          not null
#  event_content  :string(255)      not null
#  event_name     :string(255)      not null
#  necessities    :string(255)      default("必要なものはありません!")
#  overview       :string(500)
#  start_at       :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#
FactoryBot.define do
  factory :event do
    event_name { 'テスト勉強会' }
    event_content { 'テスト用の勉強会です。' }
    overview { 'これはテスト勉強会の概要です。' }
    event_capacity { 2 }
    start_at { '2020-08-31 19:00' }
    end_at { '2020-08-31 21:00' }
    necessities { '特にありません' }
    user
  end
end
