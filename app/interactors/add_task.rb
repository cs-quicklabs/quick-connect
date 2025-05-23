class AddTask < Patterns::Service
  def initialize(params, actor, contact)
    @task = Task.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_task
      add_event
    rescue
      task
    end

    task
  end

  private

  def add_task
    task.user_id = actor.id
    task.contact_id = contact.id
    task.save!
  end

  def add_event
    contact.events.create(user: actor, action: "task", action_for_context: "added new task for", trackable: task, action_context: "added new task titled")
  end

  attr_reader :task, :actor, :contact
end
