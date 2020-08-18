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
FactoryBot.define do
  factory :event do
    title { 'テスト勉強会' }
    content { 'テスト用の勉強会です。' }
    overview { 'これはテスト勉強会の概要です。' }
    capacity { 2 }
    start_at { '2020-09-30 19:00' }
    end_at { '2020-09-30 21:00' }
    necessities { '特にありません' }
    user
  end
end
