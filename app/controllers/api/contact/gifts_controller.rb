class Api::Contact::GiftsController < Api::Contact::BaseController
  before_action :set_gift, only: %i[ show edit update destroy ]

  def index
    authorize [:api, @contact, Gift]
    @gift = Gift.new
    @pagy, @gifts = pagy_nil_safe(params, @contact.gifts.order(created_at: :desc), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @gifts, message: "Contact gifts" }
  end

  def destroy
    authorize [:api, @contact, @gift]

    @gift = DestroyContactDetail.call(@contact, @api_user, @gift).result
    Event.where(trackable: @gift).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Gift was successfully deleted." } }
    end
  end

  def edit
    authorize [:api, @contact, @gift]
    render json: { success: true, data: @gift, message: "Edit Gift" }
  end

  def show
    authorize [:api, @contact, @gift]
    render json: { success: true, data: @gift, message: "Show Gift" }
  end

  def update
    authorize [:api, @contact, @gift]

    respond_to do |format|
      if @gift.update(gift_params)
        format.json { render json: { success: true, data: @gift, message: "Gift was successfully updated." } }
      else
        format.json { render json: { success: false, message: @gift.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, Gift]

    @gift = AddGift.call(gift_params, @api_user, @contact).result
    respond_to do |format|
      if @gift.persisted?
        format.json { render json: { success: true, data: @gift, message: "Gift was successfully created." } }
      else
        format.json { render json: { success: false, message: @gift.errors.full_messages.first } }
      end
    end
  end

  def status
    authorize [:api, @contact, Gift]
    @gift = Gift.find(params["gift_id"])
    @gift.update(completed: !@gift.completed)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @gift, message: "Gift was successfully updated." }
  end

  private

  def set_gift
    @gift = Gift.find(params["id"])
  end

  def gift_params
    params.require(:api_gift).permit(:name, :body, :date, :status)
  end
end
