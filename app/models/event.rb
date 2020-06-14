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
class Event < ApplicationRecord
  belongs_to :user
  has_one :access_map, dependent: :destroy
  has_many :event_tags
  has_many :tags, through: :event_tags
  has_many :event_members, dependent: :destroy
  has_many :users, through: :event_members
  has_many :comments, dependent: :destroy
  validates :event_name, presence: true
  validates :event_content, presence: true
  validates :event_content, length: { maximum: 250 }
  validates :overview, presence: true, length: { maximum: 500 }
  validates :event_capacity, presence: true, numericality: true
  validate :validate_event_capacity_not_under_1
  validate :validate_with_start_and_end_at
  validates :user_id, presence: true

  scope :recent, -> { order(updated_at: :desc) }
  scope :keyword_search,
        ->(keyword) { where('overview like ?', "%#{keyword}%").or(where('event_name like ?', "%#{keyword}%")) }

  def self.multi_keyword_search(keywords)
    search_results = Event.none
    keywords.each do |keyword|
      search_results = search_results.or(Event.keyword_search(keyword))
    end
    search_results.recent
  end

  def save_tags(savepost_tags)
    # fetch tags which this event have currently
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # devide tags by old and new
    old_tags = current_tags - savepost_tags
    new_tags = savepost_tags - current_tags

    # remove tags from this event by old_tags
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    # add tags to this event by new_tags
    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name: new_name)
      self.tags << post_tag
    end
  end

  private

  def validate_event_capacity_not_under_1
    errors.add(:event_capacity, 'は0以下に設定することができません') if event_capacity&. < 1
  end

  def validate_with_start_and_end_at
    if start_at.nil?
      errors.add(:start_at, 'を選択して下さい')
    elsif end_at.nil?
      errors.add(:end_at, 'を選択して下さい')
    elsif start_at < Time.zone.today
      errors.add(:start_at, 'は本日以降を選択して下さい')
    elsif start_at.strftime('%Y/%m/%d') != end_at.strftime('%Y/%m/%d')
      errors.add(:end_at, 'は開始日時と同じ日付を選択して下さい')
    elsif end_at < start_at
      errors.add(:end_at, 'の入力値が不正です')
    end
  end
end
