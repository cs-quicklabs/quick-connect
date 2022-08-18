class BaseController < ApplicationController
  before_action :set_user, only: %i[ index show edit update destroy create new contacts events ]
  before_action :authenticate_user!
  before_action :authenticate_account!
  include Pagy::Backend

  def authenticate_account!
    if current_user.present?
      raise Pundit::NotAuthorizedError unless current_user.account == Current.account
    end  
  end

  def pagy_nil_safe(params, collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end

  LIMIT = 9
  private
  
  def set_user
    @user = current_user
  end

  def http_request?
    !request.format.json?
  end
end
