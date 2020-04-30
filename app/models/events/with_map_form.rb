class Events::WithMapForm
  include ActiveModel::Model

  attr_reader :event

  delegate :attributes=, to: :event, prefix: true
  delegate :attributes=, to: :map, prefix: true

  validate :validate_children

  def initialize(event, attributes = {})
    @event = event
    @event.build_map unless @event.map

    super(attributes)
  end

  delegate :map, to: :event

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      event.save! && map.save!
    end
  end

  private

  def validate_children
    promote_errors(event.errors) if event.invalid?

    promote_errors(map.errors) if map.invalid?
  end

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
