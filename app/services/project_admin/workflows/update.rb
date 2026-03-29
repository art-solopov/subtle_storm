# frozen_string_literal: true

module ProjectAdmin
  module Workflows
    class Update < ApplicationService
      attribute :id, :integer
      attribute :name, :string
      attribute :icon, :string
      attribute :color, :string

      validates :name, presence: true
      validates :icon, inclusion: { in: Workflow.icons.values }
      validates :color, inclusion: { in: Workflow.colors.values }

      delegate :model_name, to: Workflow

      def persisted? = true

      def perform(workflow)
        @workflow = workflow
        @id = workflow.id
        @workflow.assign_attributes(icon:, color:, name:)
        save @workflow
      end
    end
  end
end
