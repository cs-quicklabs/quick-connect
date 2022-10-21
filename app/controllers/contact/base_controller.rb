class Contact::BaseController < BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new]
  after_action :verify_authorized
  before_action :set_details
  include Pagy::Backend

  private

  LIMIT = 10

  def set_contact
    if !@contact
      @contact = Contact.find(params[:contact_id])
    else
      return @contact
    end
  end

  def set_details
    if !@labels || !@contact_labels || @call || @event
      @labels = Label.all.order(:name)
      @contact_labels = @contact.labels
      @event = @contact.events.order(created_at: :desc).first
      @call = @contact.phone_calls.order(created_at: :desc).first
    else
      return @labels, @contact_labels
    end
  end
end
