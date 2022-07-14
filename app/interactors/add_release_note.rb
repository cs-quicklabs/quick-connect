class AddReleaseNote < Patterns::Service
  def initialize(params, actor, published)
    @release_note = ReleaseNote.new params
    @actor = actor
    @published = published
  end

  def call
    begin
      add_release_note
      add_event
    rescue
      release_note
    end

    release_note
  end

  private

  def add_release_note
    release_note.user_id = actor.id
    release_note.published = published
    release_note.save!
  end

  def add_event
    actor.events.create(user: actor, action: "release_note", action_for_context: "added a release note", trackable: release_note, action_context: "added a release note") if published
  end

  attr_reader :release_note, :actor, :published
end
