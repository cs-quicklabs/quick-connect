class Contact::GiftsController < Contact::BaseController
  before_action :set_gift, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Gift]
    @gift = Gift.new
    @pagy, @gifts = pagy_nil_safe(params, @contact.gifts.order(created_at: :desc), items: LIMIT)
    render_partial("contact/gifts/gift", collection: @gifts) if stale?(@gifts + [@contact])
  end

  def destroy
    authorize [@contact, @gift]
    @gift = DestroyContactDetail.call(@contact, current_user, @gift).result
    Event.where(trackable: @gift).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@gift) }
    end
  end

  def edit
    authorize [@contact, @gift]
  end

  def update
    authorize [@contact, @gift]

    respond_to do |format|
      if @gift.update(gift_params)
        Event.where(trackable: @debts).touch_all
        format.html { redirect_to contact_gifts_path(@contact), notice: "Gift was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@gift, template: "contact/gifts/edit", locals: { gift: @gift }) }
      end
    end
  end

  def create
    authorize [@contact, Gift]

    @gift = AddGift.call(gift_params, current_user, @contact).result
    respond_to do |format|
      if @gift.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:gifts, partial: "contact/gifts/gift", locals: { gift: @gift }) +
                               turbo_stream.replace(Gift.new, partial: "contact/gifts/form", locals: { gift: Gift.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Gift.new, partial: "contact/gifts/form", locals: { gift: @gift }) }
      end
    end
  end

  private

  def set_gift
    @gift = Gift.find(params["id"])
  end

  def gift_params
    params.require(:gift).permit(:name, :body, :date, :status)
  end
end
