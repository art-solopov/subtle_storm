# frozen_string_literal: true

module ProjectAdminHelper
  def project_admin_frame(project, &)
    tabs_id = 'project_admin_tabs'
    tabs = ProjectAdmin::TabsViewModel.new(project, frame: :project_admin, id: tabs_id)
    content = capture(&) if block_given?

    render partial: 'project_admin/frame', locals: { id: :project_admin, tabs:, tabs_id:, content: }
  end
end
