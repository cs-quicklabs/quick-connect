class DestroyDebt < Patterns::Service
  def initialize(contact, actor, debt)
    @debt = debt
    @contact = contact
    @actor = actor
  end

  def call
    begin
      destroy_debt
      update_event
    rescue
      debt
    end

    debt
  end

  private

  def destroy_debt
    @debt.destroy
  end

  def update_event
    Event.where(trackable: @debt).touch_all
    @contact.events.create(user: actor, action: "deleted", action_for_context: "deleted a debt for", action_context: "Deleted debt")
  end

  attr_reader :debt, :contact, :actor
end
