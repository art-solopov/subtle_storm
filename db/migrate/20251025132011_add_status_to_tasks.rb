class AddStatusToTasks < ActiveRecord::Migration[8.0]
  def change
    add_reference :tasks, :status, foreign_key: { to_table: :task_statuses }
  end
end
