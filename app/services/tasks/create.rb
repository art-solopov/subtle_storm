# frozen_string_literal: true

module Tasks
  class Create < ApplicationService
    attribute :project_id, :integer
    attribute :title, :string
    attribute :description, :string
    attribute :status_id, :integer

    validates :project_id, :title, presence: true

    delegate :model_name, to: Task

    attr_reader :project, :task

    def perform
      @project = Project.find(project_id)

      @task = @project.tasks.build(title:, description:, status_id:, number: @project.next_task_number)
      save @task
    end
  end
end
