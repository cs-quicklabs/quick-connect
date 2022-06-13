class UpdateReleaseNote < Patterns::Service
  def initialize(release_note, params, published)
    binding.irb
    @release_note = release_note
    @params = params
    @published = published
  end

  def call
    begin
      add_release_note
    rescue
      release_note
    end

    release_note
  end

  private

  def add_release_note
    release_note.published = published
    release_note.update(params)
  end

  attr_reader :release_note, :params, :published
end
