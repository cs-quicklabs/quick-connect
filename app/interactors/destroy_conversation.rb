class DestroyConversation < Patterns::Service
  def initialize(contact, actor, conversation)
    @conversation = conversation
    @contact = contact
    @actor = actor
  end

  def call
    begin
      destroy_conversation
      update_event
    rescue
      conversation
    end

    conversation
  end

  private

  def destroy_conversation
    @conversation.destroy
  end

  def update_event
    Event.where(trackable: @conversation).touch_all
    @contact.events.create(user: actor, action: "deleted", action_for_context: "deleted a conversation for", action_context: "Deleted conversation")
  end

  attr_reader :conversation, :contact, :actor
end
