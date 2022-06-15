class AddConversation < Patterns::Service
  def initialize(params, actor, contact)
    @conversation = Conversation.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_conversation
      add_event
    rescue
      conversation
    end
    conversation
  end

  private

  def add_conversation
    conversation.user_id = actor.id
    conversation.contact_id = contact.id
    conversation.save!
  end

  def add_event
    contact.events.create(user: actor, action: "conversation", action_for_context: "added a conversation for contact", trackable: conversation)
  end

  attr_reader :conversation, :actor, :contact
end
