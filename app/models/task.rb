class Task < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :description, length: { maximum: 500, allow_nil: true }
  validates :status, inclusion: { in: %w[Pending InProgress Completed], message: "%{value} is not a valid status" }

  # Scopes for handling deleted tasks
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  # Set default values for status
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= "Pending"
  end
end
