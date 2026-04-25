# frozen_string_literal: true

module ProjectAdmin
  module Workflows
    module Statuses
      class BatchUpdate < ApplicationService
        class TaskStatus
          include ActiveModel::Model
          include ActiveModel::Attributes

          attribute :id, :string
          attribute :_destroy, :boolean
          attribute :name
          attribute :color
          attribute :icon

          def to_model_attributes
            return attributes.except('id', '_destroy') unless persisted?

            if persisted? && _destroy
              { id:, _destroy: }
            else
              attributes.except('_destroy')
            end
          end

          def persisted? = id.present? && !id.to_s.start_with?('_')
        end

        attr_accessor :task_statuses
        attr_reader :workflow

        def self.from_model(workflow)
          new(task_statuses_attributes: workflow.task_statuses.map do |ts|
            ts.attributes.slice(*TaskStatus.attribute_names)
          end)
        end

        def task_statuses_attributes=(attributes)
          @task_statuses = Array(attributes).map { |e| TaskStatus.new(e) }
        end

        def perform(workflow)
          @workflow = workflow

          @workflow.assign_attributes(task_statuses_attributes: task_statuses.map(&:to_model_attributes))
          save @workflow
        end
      end
    end
  end
end
