# == Schema Information
#
# Table name: event_tags
#
#  id       :bigint           not null, primary key
#  event_id :integer
#  tag_id   :integer
#
class EventTag < ApplicationRecord
  belongs_to :event
  belongs_to :tag
end
