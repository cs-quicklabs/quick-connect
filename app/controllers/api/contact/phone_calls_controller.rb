class Api::Contact::PhoneCallsController < Api::Contact::BaseController
  before_action :set_phone_call, only: %i[ show edit update destroy ]
  before_action :set_phone_calls, only: %i[index create update destroy]

  def index
    authorize [@contact, PhoneCall]
    @phone_calls = @contact.phone_calls.order(created_at: :desc)
    render json: { success: true, data: { contact: @contact, phone_calls: @phone_calls }, message: "Phone calls was successfully retrieved." }
  end

  def destroy
    authorize [@contact, @phone_call]

    @phone_call.destroy
    Event.where(trackable: @phone).touch_all #fixes cache issues in activity
    render json: { success: true, data: { contact: @contact, phone_calls: @phone_calls }, message: "Phone call was successfully deleted." }
  end

  def edit
    authorize [@contact, @phone_call]
    render json: { success: true, data: { contact: @contact, phone_call: @phone_call }, message: "" }
  end

  def new
    authorize [@contact, :phone_call]
    @phone_call = PhoneCall.new
    render json: { success: true, data: { contact: @contact, phone_call: @phone_call }, message: "" }
  end

  def update
    authorize [@contact, @phone_call]

    respond_to do |format|
      if @phone_call.update(phone_call_params)
        format.json { render json: { success: true, data: { contact: @contact, phone_calls: @phone_calls }, message: "Phone call was successfully updated." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, phone_call: @phone_call }, message: @phone_call.errors } }
      end
    end
  end

  def create
    authorize [@contact, PhoneCall]

    @phone_call = AddPhoneCall.call(phone_call_params, @user, @contact).result
    respond_to do |format|
      if @phone_call.persisted?
        format.json { render json: { success: true, data: { contact: @contact, phone_calls: @phone_calls }, message: "Phone call was successfully created." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, phone_call: @phone_call }, message: @phone_call.errors } }
      end
    end
  end

  private

  def set_phone_call
    @phone_call = PhoneCall.find(params["id"])
  end

  def phone_call_params
    params.require(:api_phone_call).permit(:body)
  end
end
