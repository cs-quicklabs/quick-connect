class Api::Contact::RelativesController < Api::Contact::BaseController
  before_action :set_relative, only: %i[show edit update destroy]

  def index
    authorize [:api, @contact, Relative]
    @pagy, @relatives = pagy_nil_safe(params, Relative.includes(:contact).where("first_contact_id=? OR contact_id=?", @contact.id, @contact.id), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @relatives.as_json(:include => [:contact, :first_contact, :relation]), message: "Contact relatives" }
  end

  def destroy
    authorize [:api, @contact, @relative]
    @relative = DestroyContactDetail.call(@contact, @api_user, @relative).result
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Relative was successfully deleted." } }
    end
  end

  def edit
    authorize [:api, @contact, @relative]
    render json: { success: true, data: @relative.as_json(:include => [:contact, :first_contact, :relation]), message: "Edit Relative" }
  end

  def update
    authorize [:api, @contact, @relative]
    respond_to do |format|
      if @relative.update(relative_params)
        Event.where(trackable: @relative).touch_all
        format.json { render json: { success: true, data: @relative.as_json(:include => [:contact, :first_contact, :relation]), message: "Relative was successfully updated." } }
      else
        format.json { render json: { success: false, message: @relative.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, Relative]
    @relative = AddRelative.call(relative_params, @api_user, @contact).result
    respond_to do |format|
      if @relative.persisted?
        format.json { render json: { success: true, data: @relative, message: "Relative was successfully created." } }
      else
        format.json { render json: { success: false, message: @relative.errors.full_messages.first } }
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
