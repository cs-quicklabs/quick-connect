class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :verify_authenticity_token
  before_action :set_user, if: :json_request?
  before_action :authenticate_account!
  include Pagy::Backend
  LIMIT = 10

  def authenticate_account!
    raise Pundit::NotAuthorizedError unless Current.account
  end

  def pagy_nil_safe(params, collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end

  private

  def set_user
    @api_user = current_user
  end

  def json_request?
    request.format.json?
  end

  def pagination_meta(object) {
    current_page: object[:page],
    next_page: object[:next],
    prev_page: object[:prev],
    total_pages: object[:pages],
    total_count: object[:count],
    prev_url: object[:prev_url],
    next_url: object[:next_url],
    page_url: object[:page_url],
  }   end
end
