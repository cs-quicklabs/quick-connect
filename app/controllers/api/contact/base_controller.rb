class Api::Contact::BaseController < Api::BaseController
  protect_from_forgery with: :null_session
  before_action :set_contact, only: %i[index show edit update create destroy new]
  after_action :verify_authorized

  respond_to :json
  include Pagy::Backend

  private

  LIMIT = 10

  def set_contact
    @contact ||= Contact.find_by_id(params[:contact_id])
  end
end
