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
    errors[:title] = [ "Title cannot be blank" ] if params[:task][:title].blank?
    errors[:status] = [ "Status is invalid" ] unless valid_status?(params[:task][:status])
    errors[:priority] = [ "Priority is invalid" ] unless valid_priority?(params[:task][:priority])
    errors
  end

  def validate_update
    errors = {}
    # yet to add validation
    errors
  end

  def validate_show
    errors = {}
    errors[:id] = [ "ID cannot be blank" ] if params[:id].blank?
    errors
  end

  def validate_destroy
    errors = {}
    errors[:id] = [ "ID cannot be blank" ] if params[:id].blank?
    errors
  end

  private

  def valid_number?(value)
    value.to_i.to_s == value.to_s && value.to_i > 0
  end

  def valid_status?(status)
    %w[Backlog Todo InProgress Completed Cancelled].include?(status)
  end

  def valid_priority?(priority)
    %w[Low Medium High].include?(priority)
  end
end
