# frozen_string_literal: true

module TasksHelper
  def tasks_index_title
    return "Tasks for #{current_project.name}" if current_project

    # TODO: add conditions for filters, etc

    'Tasks'
  end

  # @param status [TaskStatus]
  def task_status_badge(status)
    # TODO: extract into a component probably

    content_tag(:span, status.name, class: ['badge', 'task-status', status.category.dasherize])
  end

  def task_status_selector(task, selector_class: '', id: nil, with_form: false)
    # TODO: extract into a component probably

    raise 'You should pass id if you want the form' if with_form && id.blank?

    render partial: 'tasks/status_selector', locals: { task:, selector_class:, id:, with_form: }
  end
end
