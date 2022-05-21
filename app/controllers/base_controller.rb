class BaseController < ApplicationController
  before_action :set_user, only: %i[ index show edit update destroy create new contacts events ]
  #before_action :authenticate_user!
  after_action :verify_authorized
  include Pagy::Backend

  def authenticate_account!
    raise Pundit::NotAuthorizedError unless current_user.account == User.find(Current.account)
  end

  LIMIT = 10

  def set_user
    @user = current_user
  end
end
