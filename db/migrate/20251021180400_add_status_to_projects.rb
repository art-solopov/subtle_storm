# frozen_string_literal: true

class AddStatusToProjects < ActiveRecord::Migration[8.0]
  def change
    change_table :projects, bulk: true do |t|
      t.string :status
      t.index :status, where: 'status IS NOT NULL'
    end
  end
end
