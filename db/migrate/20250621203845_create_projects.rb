class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps
    end
    add_index :projects, :name
    add_index :projects, :code, unique: true
  end
end
