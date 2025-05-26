class Contact::BaseController < BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new toggle toggle_favorite]
  after_action :add_count, only: %i[index]
  after_action :verify_authorized
  before_action :set_details
  include Pagy::Backend

  def toggle_favorite
    authorize @contact, :toggle_favorite?
    @contact.update(favorite: !@contact.favorite)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update(:contact_favorite, partial: "contact/favorite", locals: { contact: @contact })
      }
    end
  end

  private

  LIMIT = 10

  def add_count
    @contact.activity_count += 1
    @contact.save!
  end

  def set_contact
    @contact ||= Contact.find(params[:contact_id])
  end

  def set_details
    @labels ||= Label.all.order(:name)
    @contact_labels ||= @contact.labels
    @event ||= @contact.last_event
    @call ||= @contact.phone_calls.order(created_at: :desc).first
  end
end
