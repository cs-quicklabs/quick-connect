class Api::Contact::RelativesController < Api::Contact::BaseController
  before_action :set_relative, only: %i[show edit update destroy relative]

  def index
    authorize [@contact, Relative]
    @relatives = Relative.includes(:contact, :relation).where(first_contact_id: @contact.id)
    render json: { success: true, data: @relatives, message: "Relatives retrieved successfully." }
  end

  def destroy
    authorize [@contact, @relative]

    @relative.destroy
    Event.where(trackable: @relative).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: @relative, message: "Relative was deleted successfully." } }
    end
  end

  def edit
    authorize [@contact, @relative]
    render json: { success: true, data: @relative, message: "" }
  end

  def new
    authorize [@contact, :relative]
    @relative = Relative.new
    @contact = Contact.find(params[:contact_id])
    @relations = Relation.for_current_account.order(:name)
    render json: { success: true, data: { relative: @relative, first_contact: @contact, relations: @relations }, message: "" }
  end

  def update
    authorize [@contact, @relative]

    respond_to do |format|
      if @relative.update(relative_params)
        format.json { render json: { success: true, data: @relative, message: "Relative was updated successfully." } }
      else
        format.json { render json: { success: false, data: @relative, message: @relative.errors.full_messages } }
      end
    end
  end

  def create
    authorize [@contact, Relative]
    @relative = AddRelative.call(relative_params, current_user, @contact).result
    respond_to do |format|
      if @relative.persisted?
        format.json { render json: { success: true, data: @relative, message: "Relative was created successfully." } }
      else
        format.json { render json: { success: false, data: @relative, message: @relative.errors.full_messages } }
      end
    end
  end

  private

  def relative_params
    params.require(:api_relative).permit(:first_contact_id, :relation_id, :contact_id)
  end

  def set_relative
    @relative = Relative.find(params[:id])
  end
end
