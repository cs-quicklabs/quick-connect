class Contact::RelativesController < Contact::BaseController
  before_action :set_relative, only: %i[show edit update destroy]

  def index
    authorize [@contact, Relative]
    @relative = Relative.new
    @relation = ""
    @pagy, @relatives = pagy_nil_safe(params, Relative.includes(:contact).where("first_contact_id=? OR contact_id=?", @contact.id, @contact.id), items: LIMIT)
    render_partial("contact/relatives/relative", collection: @relatives) if stale?(@relatives + [@contact])
  end

  def destroy
    authorize [@contact, @relative]

    @relative = DestroyContactDetail.call(@contact, current_user, @relative).result

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@relative) }
    end
  end

  def edit
    authorize [@contact, @relative]
  end

  def update
    authorize [@contact, @relative]

    respond_to do |format|
      if @relative.update(relative_params)
        Event.where(trackable: @relative).touch_all
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, partial: "contact/relatives/relative", locals: { relative: @relative, contact: @contact }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, template: "contact/relatives/edit", locals: { relative: @relative, relatives: @relatives }) }
      end
    end
  end

  def create
    authorize [@contact, Relative]
    @relative = AddRelative.call(relative_params, current_user, @contact).result
    @relation = Contact.find(relative_params[:contact_id])
    respond_to do |format|
      if @relative.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:relatives, partial: "contact/relatives/relative", locals: { relative: @relative, contact: @contact }) +
                               turbo_stream.replace(Relative.new, partial: "contact/relatives/search", locals: { relative: Relative.new, relation: @relation, contact: @contact, relation: "" })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Relative.new, partial: "contact/relatives/search", locals: { relative: @relative, relation: @relation, contact: @contact }) }
      end
    end
  end

  private

  def relative_params
    params.require(:relative).permit(:first_contact_id, :relation_id, :contact_id)
  end

  def set_relative
    @relative = Relative.find(params[:id])
  end
end
