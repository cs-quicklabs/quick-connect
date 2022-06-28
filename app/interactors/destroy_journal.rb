class DestroyJournal < Patterns::Service
  def initialize(actor, journal)
    @journal = journal
    @actor = actor
  end

  def call
    begin
      destroy_journal
      update_event
    rescue
      journal
    end

    journal
  end

  private

  def destroy_journal
    @journal.destroy
  end

  def update_event
    Event.where(trackable: @journal).touch_all
    Event.create(user: actor, action: "deleted", action_for_context: "deleted a journal")
  end

  attr_reader :journal, :actor
end
