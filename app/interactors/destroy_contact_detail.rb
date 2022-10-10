class DestroyContactDetail < Patterns::Service
  def initialize(contact, actor, detail)
    @detail = detail
    @contact = contact
    @actor = actor
  end

  def call
    destroy_detail
    update_event
    begin
    rescue
      detail
    end
    detail
  end

  private

  def destroy_detail
    @detail.destroy
  end

  def update_event
    @contact.events.create(user: actor, action: "deleted", action_for_context: "deleted a " + detail.class.model_name.human.downcase + " for", action_context: "deleted a " + detail.class.model_name.human.downcase)
  end

  attr_reader :detail, :contact, :actor
end
