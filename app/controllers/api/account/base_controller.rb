class Api::Account::BaseController < Api::BaseController
  after_action :verify_authorized
  protect_from_forgery with: :null_session
end
