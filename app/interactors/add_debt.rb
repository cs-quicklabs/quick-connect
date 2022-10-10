class AddDebt < Patterns::Service
  def initialize(params, actor, contact)
    @debt = Debt.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_debt
      add_event
    rescue
      debt
    end
    debt
  end

  private

  def add_debt
    debt.user_id = actor.id
    debt.contact_id = contact.id
    debt.save!
  end

  def add_event
    contact.events.create(user: actor, action: "debt", action_for_context: "added a debt for", trackable: debt, action_context: "added a debt titled")
  end

  attr_reader :debt, :actor, :contact
end
