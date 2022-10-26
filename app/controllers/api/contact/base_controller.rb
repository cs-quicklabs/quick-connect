class Api::Contact::BaseController < Api::BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new status label remove_label relation remove_relation favorite]
  protect_from_forgery with: :null_session
  before_action :verify_authenticity_token
  LIMIT = 10
  respond_to :json

  private

  def set_contact
    if @contact
      return @contact
    end
    @contact ||= Contact.find_by_id(params[:contact_id])
  end
end
