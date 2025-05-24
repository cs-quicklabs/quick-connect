class ToggleTask < Patterns::Service
  def initialize(task, actor, contact)
    @task = task
    @actor = actor
    @contact = contact
  end

  def call
    begin
      toggle
      send_email
    rescue
      task
    end

    task
  end

  private

  def toggle_task
    task.completed = !task.completed
    task.save!
  end

  def send_email
    TasksMailer.with(actor: task.user, contact: task.contact, task: task).completed_email.deliver_later if deliver_email?
  end

  def deliver_email?
    task.completed && task.user.email_enabled
  end

  attr_reader :task, :actor, :contact
end
