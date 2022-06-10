class AddReleaseNote < Patterns::Service
  def initialize(params, actor)
    @release_note = ReleaseNote.new params
    @actor = actor
  end

  def call
    add_release_note
    add_event
    begin
    rescue
      release_note
    end

    release_note
  end

  private

  def add_release_note
    release_note.user_id = actor.id
    release_note.save!
  end

  def add_event
    Event.create(user: actor, action: "release_note", action_for_context: "added a release note for contact", trackable: release_note)
  end

  attr_reader :release_note, :actor
end
