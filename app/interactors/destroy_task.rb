class DestroyTask < Patterns::Service
  def initialize(contact, actor, task)
    @task = task
    @contact = contact
    @actor = actor
  end

  def call
    begin
      destroy_task
      update_event
    rescue
      task
    end

    task
  end

  private

  def destroy_task
    @task.destroy
  end

  def update_event
    Event.where(trackable: @task).touch_all
    @contact.events.create(user: actor, action: "deleted", action_for_context: "deleted a task for", action_context: "Deleted task")
  end

  attr_reader :task, :contact, :actor
end
