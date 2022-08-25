class Contact::BaseController < BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new]
  after_action :verify_authorized

  include Pagy::Backend

  private

  LIMIT = 10

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end
end
