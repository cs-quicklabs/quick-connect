class Api::Contact::RelativesController < Api::Contact::BaseController
  before_action :set_relative, only: %i[show edit update destroy]

  def index
    authorize [@contact, Relative]
    @relatives = Relative.includes(:contact).where("first_contact_id=?", @contact.id)

    render json: { success: true, data: @relatives.as_json(:include => [:contact, :first_contact]), message: "Contact relatives" }
  end

  def destroy
    authorize [:api, @contact, @relative]

    @relative.destroy
    Event.where(trackable: @relative).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Relative was successfully destroyed." } }
    end
  end

  def new
    authorize [:api, @contact, Relative]
    @contact = Contact.find(params[:contact_id])
    render json: { success: true, data: @contact, message: "" }
  end

  def edit
    authorize [:api, @contact, @relative]
    render json: { success: true, data: @relative, message: "" }
  end

  def update
    authorize [:api, @contact, @relative]

    respond_to do |format|
      if @relative.update(relative_params)
        format.json { render json: { success: true, data: @relative, message: "Relative was successfully updated." } }
      else
        format.json { render json: { success: false, data: @relative, message: @relative.errors.full_messages } }
      end
    end
  end

  def create
    authorize [:api, @contact, Relative]
    @relative = AddRelative.call(relative_params, current_user, @contact).result
    @relation = ""
    respond_to do |format|
      if @relative.persisted?
        format.json { render json: { success: true, data: @relative, message: "Relative was successfully created." } }
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
