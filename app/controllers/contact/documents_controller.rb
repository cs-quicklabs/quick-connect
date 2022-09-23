class Contact::DocumentsController < Contact::BaseController
  before_action :set_document, only: %i[show destroy edit update]

  def index
    authorize [@contact, Document]

    @document = Document.new
    @pagy, @documents = pagy_nil_safe(params, @contact.documents.order(created_at: :desc), items: LIMIT)

    render_partial("contact/documents/document", collection: @documents) if stale?(@documents + [@contact])
  end

  def create
    authorize [@contact, Document]

    @document = AddDocument.call(@contact, document_params, current_user).result
    respond_to do |format|
      if @document.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:documents, partial: "contact/documents/document", locals: { document: @document }) +
                               turbo_stream.replace(Document.new, partial: "contact/documents/form", locals: { document: Document.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Document.new, partial: "contact/documents/form", locals: { document: @document }) }
      end
    end
  end

  def edit
    authorize [@contact, @document]
  end

  def update
    authorize [@contact, @document]

    respond_to do |format|
      if @document.update(document_params)
        Event.where(trackable: @document).touch_all
        format.html { redirect_to contact_documents_path(@contact), notice: "Document was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@document, template: "contact/documents/edit", locals: { document: @document }) }
      end
    end
  end

  def destroy
    authorize [@contact, @document]

    @document = DestroyContactDetail.call(@contact, current_user, @document).result
    Event.where(eventable: @contact, trackable: @document).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@document) }
    end
  end

  private

  def set_document
    @document ||= Document.find(params["id"])
  end

  def document_params
    params.require(:document).permit(:filename, :comments, :link)
  end
end
