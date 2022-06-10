class AddStatus < Patterns::Service
  def initialize(params, actor)
    @status = Status.new params
    @actor = actor
  end

  def call
    add_status
    add_event
    begin
    rescue
      status
    end

    status
  end

  private

  def add_status
    status.user_id = actor.id
    status.save!
  end

  def add_event
    Event.create(user: actor, action: "status", action_for_context: "added a status for contact", trackable: status)
  end

  attr_reader :status, :actor
end
