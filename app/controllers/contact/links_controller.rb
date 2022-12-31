class Contact::LinksController < Contact::BaseController
  include ActionView::RecordIdentifier
  before_action :set_link, only: %i[show edit update destroy]

  def edit
    authorize [@contact, @link]
  end

  def create
    authorize [@contact, Link]
    @link = @contact.links.create(link_params)
    respond_to do |format|
      if @link.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:contact_links, partial: "contact/links/link", locals: { social: @link }) +
                               turbo_stream.replace(Link.new, partial: "contact/links/form", locals: { link: Link.new, contact: @contact })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Link.new, partial: "contact/links/form", locals: { link: @link, contact: @contact }) }
      end
    end
  end

  def update
    authorize [@contact, @link]
    respond_to do |format|
      if @link.update(link_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@link, partial: "contact/links/link", locals: { social: @link, contact: @contact }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@link, template: "contact/links/edit", locals: { link: @link, contact: @contact }) }
      end
    end
  end

  def destroy
    authorize [@contact, @link]
    @link.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@link) }
    end
  end

  private

  def link_params
    params.require(:link).permit(:link, :link_type, :user_id)
  end

  def set_link
    @link = @contact.links.find(params[:id])
  end
end
