class Events::WithAccessMapForm
  include ActiveModel::Model

  attr_reader :event, :tags_list

  delegate :attributes=, to: :event, prefix: true
  delegate :attributes=, to: :access_map, prefix: true

  validate :validate_children

  def initialize(event, attributes = {}, tags_list = [])
    @event = event
    @event.build_access_map unless @event.access_map
    @tags = tags_list unless tags_list.empty?

    super(attributes)
  end

  delegate :access_map, to: :event

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      event.save_tags(@tags) if @tags
      event.save! && access_map.save!
    end
  end

  private

  def validate_children
    promote_errors(event.errors) if event.invalid?
    promote_errors(access_map.errors) if access_map.invalid?
  end

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
