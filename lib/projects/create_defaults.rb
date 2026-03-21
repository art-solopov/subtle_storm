# frozen_string_literal: true

module Projects
  module CreateDefaults
    module_function

    def create_default_workflow(project)
      project.transaction do
        project.workflows.create!(name: 'Default')
      end
    end

    def create_default_task_statuses(project, workflow)
      # TODO: make it configurable/templatable?

      project.transaction do
        project.task_statuses.create!(workflow:, category: :backlog, name: 'Backlog')
        project.task_statuses.create!(workflow:, category: :analysis, name: 'To do')
        project.task_statuses.create!(workflow:, category: :development, name: 'In development')
        project.task_statuses.create!(workflow:, category: :fulfillment, name: 'Done')
      end
    end
  end
end
