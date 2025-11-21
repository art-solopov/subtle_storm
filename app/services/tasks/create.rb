# frozen_string_literal: true

module Tasks
  class Create < ApplicationService
    attribute :project_id, :integer
    attribute :title, :string
    attribute :description, :string
    attribute :status_id, :integer

    validates :project_id, :title, :status_id, presence: true

    delegate :model_name, to: Task

    attr_reader :task

    def project
      @project ||= Project.find(project_id)
    end

    def perform
      @task = project.tasks.build(title:, description:, status_id:, number: @project.next_task_number)
      save @task
    end
  end
end
