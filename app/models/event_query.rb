# frozen_string_literal: true

class EventQuery
  def initialize(entries, params)
    @entries = entries.extending(Scopes)
    @params = params
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if present?(value)
    end
    result.order(created_at: :desc)
  end

  private

  attr_reader :entries, :params

  def filter_params
    params&.reject { |_, v| v.nil? } || {}
  end

  def present?(value)
    value != "" && !value.nil?
  end

  module Scopes
    def from_date(param)
      where("created_at >= ?", Date.parse(param.to_s))
    end

    def to_date(param)
      where("created_at <= ?", Date.parse(param.to_s))
    end

    def eventable_id(param)
      where(eventable_id: param)
    end

    def action_name(param)
      where(action: param)
    end
  end
end
