class Task < ApplicationRecord
  # Validations
  validates :title, presence: { message: "Title cannot be blank" }, length: { maximum: 128, message: "Title must be 128 characters or fewer" }
  validates :description, length: { maximum: 3000, allow_blank: true, message: "Description must be 3000 characters or fewer" }
  validates :status, presence: { message: "Status cannot be blank" }, inclusion: { in: %w[Backlog Todo InProgress Completed Cancelled], message: "%{value} is not a valid status. Must be one of Backlog Todo InProgress Completed Cancelled" }
  validates :priority, presence: { message: "Priority cannot be blank" }, inclusion: { in: %w[Low Medium High], message: "%{value} is not a valid priority. Must be one of Low Medium High" }

  # Scopes for handling deleted tasks
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  # Set default values for status
  after_initialize :set_default_status, if: :new_record?
  after_initialize :set_default_priority, if: :new_record?

  private

  def set_default_status
    self.status ||= "Backlog"
  end

  def set_default_priority
    self.priority ||= "Low"
  end

  def trim_title_and_description
    self.title = title.strip if title.present?
    self.description = description.strip if description.present?
  end
end
