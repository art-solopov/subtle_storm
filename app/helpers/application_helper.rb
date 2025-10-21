# frozen_string_literal: true

module ApplicationHelper
  def path_for_projects_selector(project)
    return project_path(project) if controller_name == 'projects'

    url_for(controller: controller_name, action: :index, project:)
  end
end
