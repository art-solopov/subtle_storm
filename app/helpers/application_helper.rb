# frozen_string_literal: true

module ApplicationHelper
  def path_for_projects_selector(project)
    return project_path(project) if controller_name == 'projects'

    url_for(controller: controller_name, action: :index, project:)
  end

  def mask_icon(icon, **options)
    # Renders a span as a masked icon
    case options[:class]
    when String then options[:class] += ' mask-icon'
    when nil then options[:class] = 'mask-icon'
    else options[:class] = Array(options[:class]) + ['mask-icon']
    end
    content_tag(:span, '', style: "--icon: url(#{image_path(icon)})", **options)
  end
end
