class AddJournal < Patterns::Service
  def initialize(params, actor)
    @journal = Journal.new params
    @actor = actor
  end

  def call
    begin
      add_journal
      add_event
    rescue
      journal
    end

    journal
  end

  private

  def add_journal
    journal.user_id = actor.id
    journal.save!
  end

  def add_event
    actor.events.create(user: actor, action: "journal", action_for_context: "added a journal for contact", trackable: journal)
  end

  attr_reader :journal, :actor
end
