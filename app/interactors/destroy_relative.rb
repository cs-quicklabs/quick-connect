class DestroyRelative < Patterns::Service
  def initialize(contact, actor, relation)
    @relation = relation
    @contact = contact
    @actor = actor
  end

  def call
    begin
      destroy_relative
      update_event
    rescue
      relation
    end

    relation
  end

  private

  def destroy_relative
    @relation.destroy
  end

  def update_event
    Event.where(trackable: @relation).touch_all
    @contact.events.create(user: actor, action: "deleted", action_for_context: "deleted a relative for", action_context: "Deleted relative")
  end

  attr_reader :relation, :contact, :actor
end
