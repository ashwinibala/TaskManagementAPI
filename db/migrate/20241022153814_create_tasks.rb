class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :created_by
      t.string :deleted_by
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
