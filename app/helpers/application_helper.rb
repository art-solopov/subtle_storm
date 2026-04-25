# frozen_string_literal: true

module ApplicationHelper
  def path_for_projects_selector(project)
    return project_path(project) if controller_name == 'projects'

    url_for(controller: controller_name, action: :index, project:)
  end

  def mask_icon(icon, **options)
    klass = options.delete(:class)
    klass = Array(klass)
    klass << 'mask-icon'

    icon_path = image_path("mingcute/#{icon}.svg")
    content_tag(:span, '', class: klass, style: "--icon: url(#{icon_path})", **options)
  end
end
