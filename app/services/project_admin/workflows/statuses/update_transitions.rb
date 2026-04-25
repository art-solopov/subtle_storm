# frozen_string_literal: true

module ProjectAdmin
  module Workflows
    module Statuses
      class UpdateTransitions < ApplicationService
        class TaskStatus
          include ActiveModel::Model
          include ActiveModel::Attributes

          attribute :id, :integer
          attribute :next_status_ids
        end

        attr_accessor :task_statuses

        def self.from_model(workflow)
          new(task_statuses_attributes: workflow.task_statuses
            .includes(:next_statuses)
            .map { |ts| { id: ts.id, next_status_ids: ts.next_status_ids } })
        end

        def task_statuses_attributes=(attributes)
          @task_statuses = Array(attributes).map { |e| TaskStatus.new(e) }
        end

        def call(workflow)
          workflow.update(task_statuses_attributes: task_statuses.map(&:attributes))
        end
      end
    end
  end
end
