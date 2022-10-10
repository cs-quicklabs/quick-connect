class DestroyGroup < Patterns::Service
  def initialize(actor, group)
    @group = group
    @actor = actor
  end

  def call
    begin
      destroy_group
      update_event
    rescue
      group
    end

    group
  end

  private

  def destroy_group
    @group.destroy
  end

  def update_event
    Event.create(user: actor, action: "deleted", action_for_context: "deleted a group")
  end

  attr_reader :group, :actor
end
