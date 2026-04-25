class AddDefaultStatusToWorkflows < ActiveRecord::Migration[8.1]
  def change
    add_reference :workflows, :default_status, foreign_key: { to_table: :task_statuses }
  end
end
