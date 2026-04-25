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

        attr_accessor :workflow, :task_statuses

        attribute :default_status_id, :integer

        def self.from_model(workflow)
          new(
            workflow:,
            task_statuses_attributes: workflow.task_statuses
              .includes(:next_statuses)
              .map { |ts| { id: ts.id, next_status_ids: ts.next_status_ids } },
            default_status_id: workflow.default_status_id
          )
        end

        def task_statuses_attributes=(attributes)
          @task_statuses = Array(attributes).map { |e| TaskStatus.new(e) }
        end

        def perform(workflow)
          @workflow = workflow
          workflow.assign_attributes(default_status_id:, task_statuses_attributes: task_statuses.map(&:attributes))
          save workflow
        end

        after_success do
          if @workflow.default_status.nil?
            @workflow.task_statuses.update!(position: 0)
            return
          end

          @workflow.transaction do
            @workflow.default_status.update!(position: 0)
            seen_status_ids = Set[@workflow.default_status.id]
            statuses_to_process = [@workflow.default_status]

            until statuses_to_process.empty?
              status = statuses_to_process.pop

              next_statuses = status.next_statuses.where.not(id: seen_status_ids)
              next_statuses.update(position: status.position + 1)
              statuses_to_process.concat(next_statuses.to_a)
              seen_status_ids.merge(next_statuses.map(&:id))
            end
          end
        end
      end
    end
  end
end
