class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_account!
  after_action :verify_authorized
  before_action :set_account, only: %i[ index show edit update destroy create new ]

  LIMIT = 30

  def authenticate_account!
    raise Pundit::NotAuthorizedError unless current_user.account == Current.account
  end

  def pagy_nil_safe(params, collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end

  def set_account
    @account ||= current_user.account
  end
end
