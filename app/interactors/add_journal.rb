class AddJournal < Patterns::Service
  def initialize(params, actor)
    @journal = Journal.new params
    @actor = actor
  end

  def call
    add_journal
    add_event
    begin
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
    Event.create(user: actor, action: "journal", action_for_context: "added a journal", trackable: journal)
  end

  attr_reader :journal, :actor
end
