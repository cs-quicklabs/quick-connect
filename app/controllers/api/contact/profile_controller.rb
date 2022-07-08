class Api::Contact::ProfileController < Api::Contact::BaseController
  before_action :set_labels, only: %i[index]
  before_action :set_relations, only: %i[index]
  before_action :set_event, only: %i[index]
  include Pagy::Backend

  def index
    authorize [:api, @contact, :profile]
    render json: { success: true, data: { contact: @contact.as_json(:include => [:labels, :relations]), labels: @labels, relations: @relations, event: @event, call: @call }, message: "Contact profile" }
  end

  def label
    authorize [:api, @contact, :profile]
    @contact.labels << Label.find(params[:id])
    render json: { success: true, data: { contact: @contact.as_json(:include => [:labels, :relations]), labels: @labels, relations: @relations, event: @event, call: @call }, message: "Label was assigned successfully to contact" }
  end

  def remove_label
    authorize [:api, @contact, :profile]
    @contact.labels.destroy Label.find(params[:id])
    render json: { success: true, data: { contact: @contact.as_json(:include => [:labels, :relations]), labels: @labels, relations: @relations, event: @event, call: @call }, message: "Label was removed successfully from contact" }
  end

  def relation
    authorize [:api, @contact, :profile]
    @contact.update(relation_id: params[:id])
    render json: { success: true, data: { contact: @contact.as_json(:include => [:labels, :relations]), labels: @labels, relations: @relations, event: @event, call: @call }, message: "Relation was assigned successfully to contact" }
  end

  def remove_relation
    authorize [:api, @contact, :profile]
    @contact.update(relation_id: nil)
    render json: { success: true, data: { contact: @contact.as_json(:include => [:labels, :relations]), labels: @labels, relations: @relations, event: @event, call: @call }, message: "Relation was assigned successfully to contact" }
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
