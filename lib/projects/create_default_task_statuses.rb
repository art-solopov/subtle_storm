# frozen_string_literal: true

module Projects
  module CreateDefaultTaskStatuses
    module_function

    def create_default_task_statuses(project)
      # TODO: make it configurable/templatable?

      project.transaction do
        project.task_statuses.create!(category: :backlog, name: 'Backlog')
        project.task_statuses.create!(category: :analysis, name: 'To do')
        project.task_statuses.create!(category: :development, name: 'In development')
        project.task_statuses.create!(category: :fulfillment, name: 'Done')
      end
    end
  end
end
