class Api::Contact::ProfileController < Api::Contact::BaseController
  before_action :set_labels, only: %i[index]
  before_action :set_relations, only: %i[index]
  before_action :set_event, only: %i[index]

  def index
    authorize [@contact, Profile]
    render json: { success: true, data: { contact: @contact, labels: @labels, relations: @relations, event: @event, call: @call }, message: "Profile retrieved successfully" }
  end

  private

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
