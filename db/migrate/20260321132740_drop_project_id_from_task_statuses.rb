class DropProjectIdFromTaskStatuses < ActiveRecord::Migration[8.1]
  def change
    remove_reference :task_statuses, :project, foreign_key: true
  end
end
