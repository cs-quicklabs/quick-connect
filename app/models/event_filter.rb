# frozen_string_literal: true

class EventFilter
  include ActiveModel::Model

  KEYS = %i[
    from_date
    to_date
    action_name
    eventable_id
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
  end

  def from_date
    DateTime.parse(@from_date) if @from_date.present?
  end

  def to_date
    DateTime.parse(@to_date) if @to_date.present?
  end
end
