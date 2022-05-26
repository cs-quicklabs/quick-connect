class Api::Contact::NotesController < Api::Contact::BaseController
  before_action :set_note, only: %i[edit update destroy]

  def index
    authorize [@contact, Note]
    @notes = @contact.notes.order(created_at: :desc)
    render json: { success: true, data: { contact: @contact, notes: @notes }, message: "Notes was successfully retrieved." }
  end

  def destroy
    authorize [@contact, @note]
    @pagy, @notes = pagy_nil_safe(params, @contact.notes.order(created_at: :desc), items: LIMIT)
    @note.destroy
    Event.where(trackable: @note).touch_all #fixes cache issues in activity
    render json: { success: true, data: { contact: @contact, notes: @notes }, message: "Note was successfully deleted." }
  end

  def edit
    authorize [@contact, @note]
    render json: { success: true, data: { contact: @contact, note: @note }, message: "" }
  end

  def new
    authorize [@contact, :note]
    @note = Note.new
    render json: { success: true, data: { contact: @contact, note: @note }, message: "" }
  end

  def update
    authorize [@contact, @note]

    respond_to do |format|
      if @note.update(note_params)
        format.json { render json: { success: true, data: { contact: @contact, notes: @notes }, message: "Note was successfully updated." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, note: @note }, message: @note.errors } }
      end
    end
  end

  def create
    authorize [@contact, Note]

    @note = AddNote.call(note_params, @user, @contact).result
    respond_to do |format|
      if @note.persisted?
        format.json { render json: { success: true, data: { contact: @contact, notes: @notes }, message: "Note was successfully created." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, note: @note }, message: @note.errors } }
      end
    end
  end

  private

  def set_note
    @note = Note.find(params["id"])
  end

  def note_params
    params.require(:api_note).permit(:body)
  end
end
