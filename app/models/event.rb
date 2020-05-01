class Event < ApplicationRecord
  belongs_to :user
  has_one :map, dependent: :destroy
  validates :event_name, presence: true
  validates :event_content, presence: true
  validates :event_content, length: { maximum: 250 }
  validates :overview, presence: true, length: { maximum: 500 }
  validates :event_capacity, presence: true, numericality: true
  validate :validate_event_capacity_not_under_1
  validate :validate_with_start_and_end_at
  validates :user_id, presence: true

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