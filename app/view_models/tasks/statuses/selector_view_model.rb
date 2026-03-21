# frozen_string_literal: true

module Tasks
  module Statuses
    class SelectorViewModel
      def initialize(task, with_form: false)
        @task = task
        @with_form = with_form
      end

      def dom_id
        id = @task.persisted? ? @task.id : '_'
        "task_status_selector_#{id}"
      end

      def render_in(view_context)
        view_context.render(
          partial: 'tasks/status_selector',
          locals: { task: @task, id: dom_id, with_form: @with_form,
                    workflow_task_statuses:,
                    task_status_badge: ->(status) { task_status_badge(status, view_context) } }
        )
      end

      private

      def workflow_task_statuses
        @task.workflow.task_statuses.sort_by { |e| [e.category, e.name] }
      end

      def task_status_badge(status, view_context)
        view_context.content_tag(
          :span, status.name,
          class: ['badge', 'task-status', status.category.dasherize]
        )
      end
    end
  end
end
