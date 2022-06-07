class Api::Contact::NotesController < Api::Contact::BaseController
  before_action :set_note, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Note]

    @note = Note.new
    @pagy, @notes = pagy_nil_safe(params, @contact.notes.order(created_at: :desc), items: LIMIT)
    render json: { success: true, data: @notes, message: "Contact notes" }
  end

  def destroy
    authorize [@contact, @note]

    @note.destroy
    Event.where(trackable: @note).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Note was successfully destroyed." } }
    end
  end

  def edit
    authorize [@contact, @note]
    render json: { success: true, data: @note, message: "Note edit" }
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
    authorize [@contact, Note]

    @note = AddNote.call(note_params, @user, @contact).result
    respond_to do |format|
      if @note.persisted?
        format.json { render json: { success: true, data: @note, message: "Note was successfully created." } }
      else
        format.json { render json: { success: false, data: @note, message: @note.errors } }
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
