class AddTitleLengthConstraintToTasks < ActiveRecord::Migration[7.2]
  def change
    change_column :tasks, :title, :string, limit: 128
    change_column :tasks, :description, :text, limit: 3000
  end
end
