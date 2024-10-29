module Api
  module V1
    class TasksController < ApplicationController
      include AuthenticationHelper

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
          tasks_query = Task
          tasks_query = tasks_query.where(status: params[:statuses].split(",")) if params[:statuses].present?
          tasks_query = tasks_query.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?
          if params[:include_deleted] == "true"
            @tasks = tasks_query.order(updated_at: :desc).page(params[:page]).per(params[:per_page] || 10)
          else
            @tasks = tasks_query.active.order(updated_at: :desc).page(params[:page]).per(params[:per_page] || 10)
          end

          render json: {
            tasks: @tasks.as_json(except: [ :deleted_at, :deleted_by ]),
            meta: pagination_meta(@tasks)
          }
        rescue StandardError => e
          render_error_response("unexpected_error", "An unexpected error occurred", e.message)
        end
      end

      # GET /tasks/:id
      def show
        render json: @task.as_json(except: [ :deleted_at, :deleted_by ])
      end

      # POST /tasks
      def create
        @task = Task.new(task_params)
        user = User.find(current_user.id)
        @task.created_by = user.name

        if @task.save
          render json: @task.as_json(except: [ :deleted_at, :deleted_by ]), status: :created
        else
          render_error_response("invalid_payload", "Request body is invalid or missing some fields", @task.errors)
        end
      end

      # PUT /tasks/:id
      def update
        if @task.update(task_params)
          render json: @task.as_json(except: [ :deleted_at, :deleted_by ])
        else
          render_error_response("invalid_payload", "Request body is invalid or missing some fields", @task.errors)
        end
      end

      # DELETE /tasks/:id
      def destroy
        # Soft delete
        user = User.find(current_user.id)
        if @task.update(deleted_at: Time.current, deleted_by: user.name)
          render json: { message: "Task marked as deleted" }, status: :ok
        else
          render_error_response("invalid_payload", "Unable to delete the task", @task.errors)
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
        @task = Task.find_by(id: params[:id])

        unless @task
          render_error_response("not_found", "Task not found")
        end
      end

      def validate_index_params
        validator = TaskValidator.new(params)
        errors = validator.validate_index

        if errors.any?
          render_error_response("invalid_payload", "Request body is invalid or missing some fields", errors)
        end
      end

      def validate_show_params
        validator = TaskValidator.new(params)
        errors = validator.validate_show

        if errors.any?
          render_error_response("invalid_payload", "Request body is invalid or missing some fields", errors)
        end
      end

      def validate_create_params
        validator = TaskValidator.new(params)
        errors = validator.validate_create

        if errors.any?
          render_error_response("invalid_payload", "Request body is invalid or missing some fields", errors)
        end
      end

      def validate_update_params
        validator = TaskValidator.new(params)
        errors = validator.validate_update

        if errors.any?
          render_error_response("invalid_payload", "Request body is invalid or missing some fields", errors)
        end
      end

      def validate_destroy_params
        validator = TaskValidator.new(params)
        errors = validator.validate_destroy

        if errors.any?
          render_error_response("invalid_payload", "Request body is invalid or missing some fields", errors)
        end
      end

      # Validation of params.
      def task_params
        begin
          params.require(:task).permit(:title, :description, :status, :priority)
        rescue ActionController::ParameterMissing => e
          render_error_response("parameter_missing", "Parameter missing: #{e.param}")
          nil
        end
      end

      def render_error_response(error_code, error_message, field_errors = [])
        render json: {
          error_code: error_code,
          error_message: error_message,
          errors: field_errors.map { |field, message| { field: field, message: message } }
        }, status: :unprocessable_entity
      end
    end
  end
end
