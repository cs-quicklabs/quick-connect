class Api::Contact::PhoneCallsController < Api::Contact::BaseController
  before_action :set_phone_call, only: %i[ show edit update destroy ]

  def index
    authorize [:api, @contact, PhoneCall]

    @phone_call = PhoneCall.new
    @pagy, @phone_calls = pagy_nil_safe(params, @contact.phone_calls.order(created_at: :desc), items: LIMIT)
    render json: { success: true, data: @phone_calls, message: "Contact phone calls" }
  end

  def destroy
    authorize [:api, @contact, @phone_call]

    @phone_call.destroy
    Event.where(trackable: @phone).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Phone call was successfully destroyed." } }
    end
  end

  def edit
    authorize [:api, @contact, @phone_call]
    render json: { success: true, data: @phone_call, message: "" }
  end

  def update
    authorize [:api, @contact, @phone_call]

    respond_to do |format|
      if @phone_call.update(phone_call_params)
        format.json { render json: { success: true, data: @phone_call, message: "Phone call was successfully updated." } }
      else
        format.json { render json: { success: false, message: @phone_call.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, PhoneCall]

    @phone_call = AddPhoneCall.call(phone_call_params, @api_user, @contact).result
    respond_to do |format|
      if @phone_call.persisted?
        format.json { render json: { success: true, data: @phone_call, message: "Phone call was successfully created." } }
      else
        format.json { render json: { success: false, message: @phone_call.errors.full_messages.first } }
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
