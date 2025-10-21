# frozen_string_literal: true

class ProjectPostInitJob < ApplicationJob
  queue_as :default

  def perform(project_id)
    project = Project.preparing.find(project_id)

    create_tasks_number_sequence(project)
    project.update!(status: :ready)
  end

  private

  def create_tasks_number_sequence(project)
    Project.connection.execute "CREATE SEQUENCE IF NOT EXISTS #{project.tasks_number_sequence_name} AS INT UNSIGNED"
  end
end
