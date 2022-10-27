class Api::Contact::DocumentsController < Api::Contact::BaseController
  before_action :set_document, only: %i[show destroy edit update]

  def index
    authorize [:api, @contact, Document]

    @document = Document.new
    @pagy, @documents = pagy_nil_safe(params, @contact.documents.order(created_at: :desc), items: LIMIT)

    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @documents, message: "Contact Documents" } if stale?(@documents + [@contact])
  end

  def create
    authorize [:api, @contact, Document]

    @document = AddDocument.call(@contact, document_params, @api_user).result
    respond_to do |format|
      if @document.persisted?
        format.json { render json: { success: true, data: @document, message: "Document was successfully created." } }
      else
        format.json { render json: { success: false, message: @document.errors.full_messages.first } }
      end
    end
  end

  def edit
    authorize [:api, @contact, @document]
    render json: { success: true, data: @document, message: "Edit Document" }
  end

  def update
    authorize [:api, @contact, @document]

    respond_to do |format|
      if @document.update(document_params)
        Event.where(trackable: @document).touch_all
        format.json { render json: { success: true, data: @document, message: "Document was successfully updated." } }
      else
        format.json { render json: { success: false, message: @document.errors.full_messages.first } }
      end
    end
  end

  def destroy
    authorize [:api, @contact, @document]

    @document = DestroyContactDetail.call(@contact, @api_user, @document).result
    Event.where(eventable: @contact, trackable: @document).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Document was successfully deleted." } }
    end
  end

  private

  def set_document
    if @document
      return @document
    end
    @document ||= Document.find(params["id"])
  end

  def document_params
    params.require(:api_document).permit(:filename, :comments, :link)
  end
end
