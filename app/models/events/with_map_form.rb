class Events::WithMapForm
  include ActiveModel::Model

  attr_reader :event, :tags_list

  delegate :attributes=, to: :event, prefix: true
  delegate :attributes=, to: :map, prefix: true

  validate :validate_children

  def initialize(event, attributes = {}, tags_list = [])
    @event = event
    @event.build_map unless @event.map
    @tags = tags_list unless tags_list.empty?

    super(attributes)
  end

  delegate :map, to: :event

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      event.save_tags(@tags) if @tags
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
