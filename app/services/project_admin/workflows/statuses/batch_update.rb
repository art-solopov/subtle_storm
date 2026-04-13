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

        def call(workflow)
          @workflow = workflow
          task_status_models = @workflow.task_statuses.index_by(&:id)

          @workflow.transaction(requires_new: true) do
            task_statuses.each do |ts|
              if ts.id.start_with?('_')
                create_model!(ts)
              else
                model = task_status_models.fetch(Integer(ts.id))
                if ts._destroy
                  model.destroy!
                else
                  update_model!(model, ts)
                end
              end
            end
          end

          true
        end

        private

        def update_model!(model, form)
          model.update!(
            name: form.name,
            icon: form.icon,
            color: form.color
          )
        end

        def create_model!(form)
          @workflow.task_statuses.create!(
            name: form.name,
            icon: form.icon,
            color: form.color
          )
        end
      end
    end
  end
end
