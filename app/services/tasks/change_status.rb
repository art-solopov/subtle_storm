# frozen_string_literal: true

module Tasks
  class ChangeStatus < ApplicationService
    attribute :status_id, :integer

    validates :status_id, presence: true
    attr_reader :task

    delegate :model_name, to: Task

    after_success :broadcast_status_changes

    def perform(task)
      @task = task
      @id = task.id

      return false unless valid?

      @task.status_id = status_id
      save @task
    end

    private

    def broadcast_status_changes
      view_model_with_form = Tasks::Statuses::SelectorViewModel.new(task, with_form: true)
      view_model_no_form = Tasks::Statuses::SelectorViewModel.new(task, with_form: false)

      task.broadcast_replace_to [task, :status, :with_form],
                                target: view_model_with_form.dom_id,
                                renderable: view_model_with_form
      task.broadcast_replace_to [task, :status, :no_form],
                                target: view_model_no_form.dom_id,
                                renderable: view_model_no_form
    end
  end
end
