class ReleaseNotesController < BaseController
  before_action :set_release_note, only: %i[ show edit update destroy ]

  def index
    authorize ReleaseNote
    @pagy, @release_notes = pagy_nil_safe(params, ReleaseNote.order(created_at: :desc), items: LIMIT)
    render_partial("release_notes/release_note", collection: @release_notes, cached: true) if stale?(@release_notes)
  end

  def destroy
    authorize @release_note
    @release_note.destroy
    respond_to do |format|
      format.html { redirect_to release_notes_path, notice: "Release Note was successfully deleted.", status: :see_other }
    end
  end

  def release
    authorize ReleaseNote
    @pagy, @release_notes = pagy_nil_safe(params, ReleaseNote.published.order(created_at: :desc), items: LIMIT)
    render_partial("release_notes/release_note", collection: @release_notes, cached: true) if stale?(@release_notes)
  end

  def whatsnew
    authorize ReleaseNote
    @pagy, @release_notes = pagy_nil_safe(params, ReleaseNote.published.order(created_at: :desc), items: LIMIT)
    render_partial("release_notes/release_note", collection: @release_notes, cached: true) if stale?(@release_notes)
  end

  def new
    authorize ReleaseNote
    @release_note = ReleaseNote.new
  end

  def edit
    authorize @release_note
  end

  def show
    authorize @release_note
  end

  def update
    authorize @release_note
    respond_to do |format|
      @release_note = UpdateReleaseNote.call(@release_note, release_note_params, params[:draft].nil?).result
      if @release_note.update(release_note_params)
        format.html { redirect_to release_notes_path, notice: "Release Note was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@release_note, partial: "release_notes/form", locals: { release_note: @release_note, title: "Edit Release Note", subtitle: "Please update existing Release Note" }) }
      end
    end
  end

  def create
    authorize ReleaseNote
    @release_note = AddReleaseNote.call(release_note_params, current_user, params[:draft].nil?).result
    respond_to do |format|
      if @release_note.errors.empty?
        format.html { redirect_to release_notes_path, notice: "Release Note was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ReleaseNote.new, partial: "release_notes/form", locals: { release_note: @release_note, title: "Add New Release Note", subtitle: "Please add release note" }) }
      end
    end
  end

  private

  def set_release_note
    if @release_note
      return @release_note
    end
    @release_note = ReleaseNote.find(params["id"])
  end

  def release_note_params
    params.require(:release_note).permit(:title, :body)
  end
end
