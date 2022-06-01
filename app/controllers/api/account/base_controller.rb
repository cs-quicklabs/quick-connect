class Api::Account::BaseController < Api::BaseController
  protect_from_forgery with: :null_session

  before_action :verify_authenticity_token
end
