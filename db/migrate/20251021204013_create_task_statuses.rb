class CreateTaskStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :task_statuses do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :category, limit: 2, unsigned: true, null: false

      t.index %i[project_id name], unique: true
      t.index %i[project_id category name]
      t.timestamps
    end
  end
end
