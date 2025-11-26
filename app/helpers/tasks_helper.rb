# frozen_string_literal: true

module TasksHelper
  def tasks_index_title
    return "Tasks for #{current_project.name}" if current_project

    # TODO: add conditions for filters, etc

    'Tasks'
  end

  def task_status_selector(task, with_form: false)
    render Tasks::Statuses::SelectorViewModel.new(task, with_form:)
  end
end
