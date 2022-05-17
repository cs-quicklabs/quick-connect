class TasksMailer < ApplicationMailer
  def added_email
    @contact = params[:contact]
    @actor = params[:actor]
    @task = params[:task]
    mail(to: @contact.email, subject: "New Task Assigned", template_path: "mailers/tasks_mailer")
  end

  def completed_email
    @contact = params[:contact]
    @actor = params[:actor]
    @task = params[:task]
    mail(to: @actor.email, subject: "Task Completed", template_path: "mailers/tasks_mailer")
  end
end
