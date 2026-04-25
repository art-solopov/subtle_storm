class CreateTaskStatusTransitions < ActiveRecord::Migration[8.1]
  def change
    create_table :task_status_transitions do |t|
      t.belongs_to :from, null: false, foreign_key: { to_table: :task_statuses }
      t.belongs_to :to, null: false, foreign_key: { to_table: :task_statuses }

      t.timestamps
    end
  end
end
