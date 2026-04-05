# frozen_string_literal: true

module Tasks
  module Statuses
    class SelectorViewModel
      ICONS = {
        new: 'add_circle_fill',
        archived: 'archive_line',
        done: 'checks_line',
        circle_dash: 'circle_dash_line',
        hammer: 'hammer_fill',
        play: 'play_circle_fill',
        tool: 'tool_line'
      }.freeze

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
        @task.workflow.task_statuses.sort_by { |e| [e.position, e.name] }
      end

      def task_status_badge(status, view_context)
        view_context.content_tag(
          :span, view_context.mask_icon(icon(status)) + status.name,
          class: ['badge', 'task-status', status.color]
        )
      end

      def icon(status)
        ICONS.fetch(status.icon.to_sym)
      end
    end
  end
end
