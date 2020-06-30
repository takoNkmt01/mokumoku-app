# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  action          :string(255)      default(""), not null
#  checked         :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  comment_id      :integer
#  entry_id        :integer
#  event_id        :integer
#  member_entry_id :integer
#  message_id      :integer
#  visited_id      :integer          not null
#  visitor_id      :integer          not null
#
# Indexes
#
#  index_notifications_on_comment_id       (comment_id)
#  index_notifications_on_entry_id         (entry_id)
#  index_notifications_on_event_id         (event_id)
#  index_notifications_on_member_entry_id  (member_entry_id)
#  index_notifications_on_message_id       (message_id)
#  index_notifications_on_visited_id       (visited_id)
#  index_notifications_on_visitor_id       (visitor_id)
#
