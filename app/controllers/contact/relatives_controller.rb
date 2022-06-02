class Contact::RelativesController < Contact::BaseController
  before_action :set_relative, only: %i[show edit update destroy]

  def index
    authorize [@contact, Relative]
    @relative = Relative.new
    @relation = ""
    @relatives = Relative.includes(:contact).where("first_contact_id=? OR contact_id=?", @contact.id, @contact.id)
  end

  def destroy
    authorize [@contact, @relative]

    @relative.destroy
    Event.where(trackable: @relative).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@relative) }
    end
  end

  def edit
    authorize [@contact, @relative]
  end

  def show
    authorize [@contact, @relative]
  end

  def update
    authorize [@contact, @relative]

    respond_to do |format|
      if @relative.update(relative_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, partial: "contact/relatives/relative", locals: { relative: @relative, contact: @contact }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, template: "contact/relatives/edit", locals: { relative: @relative, relatives: @relatives }) }
      end
    end
  end

  def create
    authorize [@contact, Relative]
    @relative = AddRelative.call(relative_params, current_user, @contact).result
    @relation = ""
    respond_to do |format|
      if @relative.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:relatives, partial: "contact/relatives/relative", locals: { relative: @relative, contact: @contact }) +
                               turbo_stream.replace(Relative.new, partial: "contact/relatives/search", locals: { relative: Relative.new, relation: @relation, contact: @contact })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(relative.new, partial: "contact/relatives/form", locals: { relative: @relative, relatives: @relatives }) }
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
