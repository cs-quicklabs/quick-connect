class AddRelative < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, actor, contact)
    @relative = Relative.new(params)
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_relative
      add_event
    rescue
      relative
    end
    relative
  end

  private

  def add_relative
    relative.save!
  end

  def add_event
    @contact.events.create(user: actor, action: "relation", action_for_context: "added a relative for", trackable: relative, action_context: "Added relative")
  end

  attr_reader :contact, :actor, :relative
end
