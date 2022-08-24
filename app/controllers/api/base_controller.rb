class Api::BaseController < ApplicationController
  
  protect_from_forgery with: :exception, unless: :json_request?
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :verify_authenticity_token
  before_action :set_user, if: :json_request?
  before_action :authenticate_account!

  rescue_from ActionController::InvalidAuthenticityToken,
              with: :token_verification
  rescue_from ActionController::InvalidAuthenticityToken, with: :token_verification
  before_action :set_current_user, if: :json_request?

  LIMIT = 10 

  def authenticate_account!
    raise Pundit::NotAuthorizedError unless Current.account
  end

  def pagy_nil_safe(params, collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end

  def token_verification
    json_request? ? invalid_auth_token : invalid_token
  end

  private

  def set_user
    @api_user = User.find_by(account: Current.account)
  end

  def set_current_user
    @current_user ||= warden.authenticate(scope: :api_user)
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
