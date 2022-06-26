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

  private

  def set_user
    @api_user = User.find_by(account: Current.account)
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
