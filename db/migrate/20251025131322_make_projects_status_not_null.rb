class MakeProjectsStatusNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :projects, :status, false
  end
end
