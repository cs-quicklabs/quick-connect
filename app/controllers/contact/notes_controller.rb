class Contact::NotesController < Contact::BaseController
  before_action :set_note, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Note]

    @note = Note.new
    @pagy, @notes = pagy_nil_safe(params, @contact.notes.order(created_at: :desc), items: LIMIT)
    render_partial("notes/note", collection: @notes) if stale?(@notes)
  end

  def destroy
    authorize [@contact, @note]

    @note.destroy
    Event.where(trackable: @note).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@note) }
    end
  end

  def edit
    authorize [@contact, @note]
  end

  def show
    authorize [@contact, @note]
  end

  def update
    authorize [@contact, @note]

    respond_to do |format|
      if @note.update(note_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@note, partial: "Contact/notes/note", locals: { note: @note }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@note, template: "Contact/notes/edit", locals: { note: @note }) }
      end
    end
  end

  def create
    authorize [@contact, Note]

    @note = AddNote.call(note_params, current_user, @contact).result
    respond_to do |format|
      if @note.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:notes, partial: "Contact/notes/note", locals: { note: @note }) +
                               turbo_stream.replace(Note.new, partial: "Contact/notes/form", locals: { note: Note.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Note.new, partial: "notes/form", locals: { note: @note }) }
      end
    end
  end

  private

  def set_note
    @note = Note.find(params["id"])
  end

  def note_params
    params.require(:note).permit(:body)
  end
end
