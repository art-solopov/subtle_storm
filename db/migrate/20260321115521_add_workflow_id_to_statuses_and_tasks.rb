class AddWorkflowIdToStatusesAndTasks < ActiveRecord::Migration[8.1]
  def change
    add_belongs_to :tasks, :workflow
    add_belongs_to :task_statuses, :workflow
  end
end
