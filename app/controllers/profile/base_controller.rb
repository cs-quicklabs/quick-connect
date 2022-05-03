class Profile::BaseController < BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new]
  after_action :verify_authorized
  include Pagy::Backend

  private

  def set_contact
    @contact ||= Contact.find_by_id(params[:profile_id]) 
  end

end
