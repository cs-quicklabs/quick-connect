class Api::Contact::ProfileController < Api::Contact::BaseController
  before_action :set_details, only: %i[index]
  include Pagy::Backend

  def index
    authorize [:api, @contact, :profile]
    render json: { success: true, data: { contact: @contact.as_json(:include => [:labels, :relations]), labels: @labels, relations: @relations, event: @event, call: @call }, message: "Contact profile" } if stale?(@labels + @relations + [@event] + [@call] + [@contact])
  end

  def favorite
    authorize [:api, @contact, :profile]
    @contact.update(favorite: !@contact.favorite)
    render json: { success: true, data: { contact: @contact.as_json(:include => [:labels, :relations]), labels: @labels, relations: @relations, event: @event, call: @call }, message: "Favorite was assigned successfully to contact" }
  end

  private

  def set_details
    if @labels && @relations && @event && @call
      return @labels, @relations, @call, @event
    end
    @labels ||= Label.all.order(:name)
    @relations ||= Relation.all.order(:name)
    @event = @contact.last_event
    @call = @contact.phone_calls.order(created_at: :desc).first
  end
end
