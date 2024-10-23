# app/validators/task_validator.rb
class TaskValidator
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def validate_index
    errors = {}
    if params[:page].present? && !valid_number?(params[:page])
      errors[:page] = "must be a positive integer"
    end

    if params[:per_page].present? && !valid_number?(params[:per_page])
      errors[:per_page] = "must be a positive integer"
    end
    errors
  end

  def validate_show
    errors = {}

    unless valid_number?(params[:id])
      errors[:id] = "must be a valid positive integer"
    end
    errors
  end

  def validate_create
    errors = {}

    if params[:task].blank?
      errors[:task] = "cannot be blank"
    end

    errors
  end

  def validate_update
    errors = {}

    if params[:task].blank?
      errors[:task] = "cannot be blank"
    end

    errors
  end

  def validate_destroy
    errors = {}

    task = Task.active.find_by(id: params[:id])
    unless task
      errors[:task] = "Task not found or already deleted"
    end

    errors
  end

  private

  def valid_number?(value)
    value.to_i.to_s == value.to_s && value.to_i > 0
  end
end
