class Api::Contact::TasksController < Api::Contact::BaseController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Task]
    @tasks = @contact.tasks.order(created_at: :desc)
    render json: { success: true, data: { contact: @contact, phone_cals: @phone_calls }, message: "Phone calls was successfully retrieved." }
  end

  def destroy
    authorize [@contact, @task]

    @task.destroy
    Event.where(trackable: @task).touch_all #fixes cache issues in activity
    render json: { success: true, data: { contact: @contact, tasks: @tasks }, message: "task was successfully deleted." }
  end

  def edit
    authorize [@contact, @task]
    render json: { success: true, data: { contact: @contact, task: @task }, message: "" }
  end

  def show
    authorize [@contact, @task]
    render json: { success: true, data: { contact: @contact, task: @task }, message: "" }
  end

  def new
    authorize [@contact, :task]
    @task = Task.new
    render json: { success: true, data: { contact: @contact, task: @task }, message: "" }
  end

  def update
    authorize [@contact, @task]
    respond_to do |format|
      if @task.update(task_params)
        format.json { render json: { success: true, data: { contact: @contact, tasks: @tasks }, message: "Task was successfully updated." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, task: @task }, message: @task.errors } }
      end
    end
  end

  def create
    authorize [@contact, Task]
    @task = AddTask.call(task_params, @user, @contact).result
    respond_to do |format|
      if @task.persisted?
        format.json { render json: { success: true, data: { contact: @contact, tasks: @tasks }, message: "Task was successfully created." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, task: @task }, message: @task.errors } }
      end
    end
  end

  private

  def set_task
    @task = Task.find(params["id"])
  end

  def task_params
    params.require(:api_task).permit(:title, :body, :due_date)
  end
end
