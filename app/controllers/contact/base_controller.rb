class Contact::BaseController < BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new]
  after_action :verify_authorized
  before_action :set_labels, only: %i[index]
  before_action :set_relations, only: %i[index]
  before_action :set_event, only: %i[index]

  include Pagy::Backend

  private

  LIMIT = 20

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def set_labels
    @labels ||= Label.all.order(:name)
  end

  def set_relations
    @relations ||= Relation.all.order(:name)
  end

  def set_event
    @event = @contact.events.order(created_at: :desc).first
    @call = @contact.phone_calls.order(created_at: :desc).first
  end
end
