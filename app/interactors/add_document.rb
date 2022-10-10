class AddDocument < Patterns::Service
  def initialize(contact, params, actor)
    @contact = contact
    @document = @contact.documents.new params
    @actor = actor
  end

  def call
    begin
      add_document
      add_event
    rescue
      document
    end

    document
  end

  private

  def add_document
    document.user_id = actor.id
    document.save!
  end

  def add_event
    contact.events.create(user: actor, action: "document", action_for_context: "added new document for", trackable: document, action_context: "added new document named")
  end

  attr_reader :contact, :document, :actor
end
