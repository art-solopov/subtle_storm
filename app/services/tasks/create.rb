# frozen_string_literal: true

module Tasks
  class Create < ApplicationService
    attribute :project_id, :integer
    attribute :title, :string
    attribute :description, :string

    validates :project_id, :title, presence: true

    delegate :model_name, to: Task

    attr_reader :project, :task

    def perform
      @project = Project.find(project_id)

      @task = @project.tasks.build(title:, description:, number: @project.next_task_number)
      @task.save.tap { @errors = @task.errors }
    end
  end
end
