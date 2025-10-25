# frozen_string_literal: true

module Tasks
  class Update < ApplicationService
    attribute :id, :integer
    attribute :title, :string
    attribute :description, :string
    attribute :status_id, :integer

    validates :title, presence: true

    delegate :model_name, to: Task

    def persisted? = true

    def perform(task)
      @task = task
      @id = task.id
      @task.assign_attributes(title:, description:, status_id:)
      save @task
    end
  end
end
