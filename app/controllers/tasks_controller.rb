class TasksController < ApplicationController
  before_action :authenticate_request
  before_action :set_task, only: [ :show, :update, :destroy ]
  before_action :validate_index_params, only: [ :index ]
  before_action :validate_show_params, only: [ :show ]
  before_action :validate_create_params, only: [ :create ]
  before_action :validate_update_params, only: [ :update ]
  before_action :validate_destroy_params, only: [ :destroy ]

  # GET /tasks
  def index
    begin
      # Fetch active tasks with pagination
      @tasks = Task.active.page(params[:page]).per(params[:per_page] || 10)

      render json: {
        tasks: @tasks,
        meta: pagination_meta(@tasks)
      }
    rescue StandardError => e
      render json: { error: "An unexpected error occurred", details: e.message }, status: :internal_server_error
    end
  end

  # GET /tasks/:id
  def show
    @task = Task.active.find_by(id: params[:id])

    if @task
      render json: @task
    else
      render json: { error: "Task not found" }, status: :not_found
    end
  end


  # POST /tasks
  def create
    @task = Task.new(task_params)
    user = User.find(current_user.id)
    @task.created_by = user.name

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PUT /tasks/:id
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    # Soft delete
    user = User.find(current_user.id)
    if @task.update(deleted_at: Time.current, deleted_by: user.name)
      render json: { message: "Task marked as deleted" }, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Pagination for GET API.
  def pagination_meta(tasks)
    {
      current_page: tasks.current_page,
      next_page: tasks.next_page,
      prev_page: tasks.prev_page,
      total_pages: tasks.total_pages,
      total_count: tasks.total_count
    }
  end

  # task helper.
  def set_task
    @task = Task.deleted.find_by(id: params[:id])

    unless @task
      render json: { error: "Task not found" }, status: :not_found
    end
  end

  def validate_index_params
    validator = TaskValidator.new(params)
    errors = validator.validate_index

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity and return
    end
  end

  def validate_show_params
    validator = TaskValidator.new(params)
    errors = validator.validate_show

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity and return
    end
  end

  def validate_create_params
    validator = TaskValidator.new(params)
    errors = validator.validate_create

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity and return
    end
  end

  def validate_update_params
    validator = TaskValidator.new(params)
    errors = validator.validate_update

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity and return
    end
  end

  def validate_destroy_params
    validator = TaskValidator.new(params)
    errors = validator.validate_destroy

    if errors.any?
      render json: { errors: errors }, status: :unprocessable_entity and return
    end
  end

  # Validation of params.
  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end


# showing up completed and deleted tasks and undelete as add ons
