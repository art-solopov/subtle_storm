# frozen_string_literal: true

module Workflows
  class DisplayViewModel
    DEFAULT_ICON = 'task_line'
    ICONS = {
      warning: 'warning_line'
    }.freeze

    def initialize(workflow, full: false)
      @workflow = workflow
      @full = full
    end

    def icon
      icon = ICONS.fetch(@workflow.icon.to_sym, DEFAULT_ICON)

      "mingcute/#{icon}.svg"
    end

    def render_in(view_context)
      view_context.render(
        partial: 'workflows/display',
        locals: @workflow.attributes.symbolize_keys.merge(icon:, full: @full)
      )
    end
  end
end
