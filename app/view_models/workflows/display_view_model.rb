# frozen_string_literal: true

module Workflows
  class DisplayViewModel
    DEFAULT_ICON = 'task_line'
    ICONS = {
      warning: 'warning_line'
    }.freeze

    def initialize(workflow, badge: false, full: false)
      @workflow = workflow
      @badge = badge
      @full = full
    end

    attr_reader :full, :badge

    def icon
      ICONS.fetch(@workflow.icon.to_sym, DEFAULT_ICON)
    end

    def render_in(view_context)
      view_context.render(
        partial: 'workflows/display',
        locals: @workflow.attributes.symbolize_keys.merge(full:, badge:, icon:)
      )
    end
  end
end
