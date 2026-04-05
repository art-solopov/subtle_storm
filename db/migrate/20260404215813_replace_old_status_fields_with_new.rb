class ReplaceOldStatusFieldsWithNew < ActiveRecord::Migration[8.1]
  def change
    change_table :task_statuses, bulk: true do |t|
      t.string :icon
      t.string :color
      t.integer :position, default: 0

      t.remove :category, type: :integer
    end
  end
end
