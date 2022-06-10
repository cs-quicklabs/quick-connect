class Api::ReleaseNotesController < Api::BaseController
  before_action :set_release_note, only: %i[ show edit update destroy ]

  def index
    @pagy, @release_notes = pagy_nil_safe(params, ReleaseNote.order(created_at: :desc), items: LIMIT)
    render json: { suceess: true, data: @release_notes, message: " Release Notes were successfully retrived" }
  end
end
