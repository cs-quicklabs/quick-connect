class Api::Contact::NotesController < Api::Contact::BaseController
  before_action :set_note, only: %i[ show edit update destroy ]

  def index
    authorize [:api, @contact, Note]

    @note = Note.new
    @pagy, @notes = pagy_nil_safe(params, @contact.notes.order(created_at: :desc), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @notes, message: "Contact notes" } if stale?(@notes + [@contact])
  end

  def destroy
    authorize [:api, @contact, @note]
    @note = DestroyContactDetail.call(@contact, @api_user, @note).result
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Note was successfully deleted." } }
    end
  end

  def edit
    authorize [:api, @contact, @note]
    render json: { success: true, data: @note, message: " Edit Note" }
  end

  def update
    authorize [:api, @contact, @note]

    respond_to do |format|
      if @note.update(note_params)
        Event.where(trackable: @note).touch_all
        format.json { render json: { success: true, data: @note, message: "Note was successfully updated." } }
      else
        format.json { render json: { success: false, message: @note.errors.full_messages.first } }
      end
    end
  end

  def update
    authorize [@contact, @note]

    respond_to do |format|
      if @note.update(note_params)
        format.json { render json: { success: true, data: @note, message: "Note was successfully updated." } }
      else
        format.json { render json: { success: false, data: @note, message: @note.errors } }
      end
    end
  end

  def create
    authorize [:api, @contact, Note]
    @note = AddNote.call(note_params, @api_user, @contact).result
    respond_to do |format|
      if @note.persisted?
        format.json { render json: { success: true, data: @note, message: "Note was successfully created." } }
      else
        format.json { render json: { success: false, message: @note.errors.full_messages.first } }
      end
    end
  end

  private

  def set_note
    @note = Note.find(params["id"])
  end

  def note_params
    params.require(:api_note).permit(:title, :body)
  end
end
