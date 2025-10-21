# frozen_string_literal: true

module Projects
  class PostInitJob < ApplicationJob
    queue_as :default

    include Projects::CreateDefaultTaskStatuses

    def perform(project_id)
      project = Project.preparing.find(project_id)

      project.transaction do
        create_tasks_number_sequence(project)
        create_default_task_statuses(project)
        project.update!(status: :ready)
      end
    end

    private

    def create_tasks_number_sequence(project)
      Project.connection.execute "CREATE SEQUENCE IF NOT EXISTS #{project.tasks_number_sequence_name} AS INT UNSIGNED"
    end
  end
end
