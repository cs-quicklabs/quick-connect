class Contact::BaseController < BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new]
  after_action :verify_authorized
  before_action :set_details
  include Pagy::Backend

  private

  LIMIT = 10

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def set_details
    @labels = Label.all.order(:name)
    @relations = Relation.all.order(:name)
  end
end
