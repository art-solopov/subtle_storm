# frozen_string_literal: true

module Tasks
  class ChangeStatus < ApplicationService
    attribute :status_id, :integer

    validates :status_id, presence: true
    attr_reader :task

    delegate :model_name, to: Task

    def perform(task)
      @task = task
      @id = task.id

      return false unless valid?

      @task.status_id = status_id
      save @task
    end
  end
end
