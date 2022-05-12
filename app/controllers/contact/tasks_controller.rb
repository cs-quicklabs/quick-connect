class Contact::TasksController < Contact::BaseController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Task]
    @task = Task.new
    @pagy, @tasks = pagy_nil_safe(params, @contact.tasks.order(created_at: :desc), items: LIMIT)
    render_partial("tasks/task", collection: @tasks) if stale?(@tasks)
  end

  def destroy
    authorize [@contact, @task]

    @task.destroy
    Event.where(trackable: @task).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
    end
  end

  def edit
    authorize [@contact, @task]
  end

  def show
    authorize [@contact, @task]
  end

  def update
    authorize [@contact, @task]

    respond_to do |format|
      if @task.update(task_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: "Contact/tasks/task", locals: { task: @task }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, template: "Contact/tasks/edit", locals: { task: @task }) }
      end
    end
  end

  def create
    authorize [@contact, Task]

    @task = AddTask.call(task_params, current_user, @contact).result
    respond_to do |format|
      if @task.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:tasks, partial: "Contact/tasks/task", locals: { task: @task }) +
                               turbo_stream.replace(Task.new, partial: "Contact/tasks/form", locals: { task: Task.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Task.new, partial: "Contact/tasks/form", locals: { task: @task }) }
      end
    end
  end

  private

  def set_task
    @task = Task.find(params["id"])
  end

  def task_params
    params.require(:task).permit(:title, :body, :due_date)
  end
end
