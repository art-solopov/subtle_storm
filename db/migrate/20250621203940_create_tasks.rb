class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
