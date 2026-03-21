class CreateWorkflows < ActiveRecord::Migration[8.1]
  def change
    create_table :workflows do |t|
      t.belongs_to :project, null: false, foreign_key: true
      t.string :name, null: false
      t.string :icon, null: false
      t.string :color, null: false

      t.index %i[project_id name], unique: true

      t.timestamps
    end
  end
end
