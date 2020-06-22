# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  reply_to   :integer
#  text       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer          not null
#  user_id    :integer          not null
#
FactoryBot.define do
  factory :comment do
    text { 'あらかじめ用意されたコメント' }
    event
    user
  end
end
