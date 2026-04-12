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
          task_status_models = @workflow.task_statuses.index_by(&:id)

          @workflow.transaction(requires_new: true) do
            task_statuses.each do |ts|
              model = task_status_models.fetch(ts.id.to_i)
              if ts._destroy
                model.destroy!
              else
                model.update!(
                  name: ts.name,
                  icon: ts.icon,
                  color: ts.color
                )
              end
            end
          end

          true
        end
      end
    end
  end
end
