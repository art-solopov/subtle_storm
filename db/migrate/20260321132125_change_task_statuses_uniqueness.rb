class ChangeTaskStatusesUniqueness < ActiveRecord::Migration[8.1]
  def change
    change_table :task_statuses, bulk: true do |t|
      t.remove_index %i[project_id name], unique: true
      t.remove_index %i[project_id category name]
      t.index %i[workflow_id name], unique: true
    end
  end
end
