class ReleaseNotePublishReflex < ApplicationReflex
  def publish
    release_note = ReleaseNote.find(element.dataset["release-note-id"])
    release_note.update(published: true)
    actor = release_note.user
    actor.events.create(user: actor, action: "release_note", action_for_context: "added a release note for contact", trackable: release_note)
    release_note.save!
  end
end
