class Api::ReleaseNotesController < Api::BaseController
  before_action :set_release_note, only: %i[ show edit update destroy ]

  def index
    authorize [:api, :release_note]
    @pagy, @release_notes = pagy_nil_safe(params, ReleaseNote.order(created_at: :desc), items: LIMIT)
    render json: { suceess: true, data: @release_notes, message: " Release Notes were successfully retrived" }
  end

  def show
    authorize [:api, @release_note]
    render json: { suceess: true, data: @release_note, message: " Release Note was successfully retrived" }
  end

  private

  def set_release_note
    @release_note ||= ReleaseNote.find(params[:id])
  end
end
