class AddNullFalseToTaskStatusesWorkflow < ActiveRecord::Migration[8.1]
  def change
    change_column_null :task_statuses, :workflow_id, false
  end
end
