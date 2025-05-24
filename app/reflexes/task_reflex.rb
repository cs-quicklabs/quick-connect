class TaskReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def toggle_task
    task = Task.find(element.dataset[:id])
    task.update(completed: !task.completed)
    TasksMailer.with(actor: task.user, contact: task.contact, task: task).completed_email.deliver_later if deliver_email?(task)
    task.save!
  end
end
