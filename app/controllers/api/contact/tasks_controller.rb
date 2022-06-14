class Api::Contact::TasksController < Api::Contact::BaseController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    authorize [:api, @contact, Task]
    @task = Task.new
    @pagy, @tasks = pagy_nil_safe(params, @contact.tasks.order(created_at: :desc), items: LIMIT)
    render json: { success: true, data: @tasks, message: "Contact tasks" }
  end

  def destroy
    authorize [:api, @contact, @task]

    @task.destroy
    Event.where(trackable: @task).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Task was successfully destroyed." } }
    end
  end

  def edit
    authorize [:api, @contact, @task]
    render json: { success: true, data: @task, message: "" }
  end

  def show
    authorize [:api, @contact, @task]
    render json: { success: true, data: @task, message: "" }
  end

  def update
    authorize [:api, @contact, @task]

    respond_to do |format|
      if @task.update(task_params)
        format.json { render json: { success: true, data: @task, message: "Task was successfully updated." } }
      else
        format.json { render json: { success: false, message: @task.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, Task]

    @task = AddTask.call(task_params, @api_user, @contact).result
    respond_to do |format|
      if @task.persisted?
        format.json { render json: { success: true, data: @task, message: "Task was successfully created." } }
      else
        format.json { render json: { success: false, message: @task.errors.full_messages.first } }
      end
    end
  end

  def status
    authorize [:api, @contact, Task]
    @task = Task.find(params["task_id"])
    @task.update(completed: !@task.completed)
    render json: { success: true, data: @task, message: "Task was successfully updated." }
  end

  private

  def set_task
    @task = Task.find(params["id"])
  end

  def task_params
    params.require(:api_task).permit(:title, :body, :due_date)
  end
end
