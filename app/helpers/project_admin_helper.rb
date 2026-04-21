# frozen_string_literal: true

module ProjectAdminHelper
  FRAME_ID = 'admin_frame'
  TABS_ID = 'admin_tabs'

  def project_admin_frame(project, &)
    links = {
      'Data' => edit_project_path(project),
      'Workflows' => project_admin_workflows_path(project)
    }

    title = "Project #{project.name}"
    admin_frame(links, title:, back_path: project_path(project), &)
  end

  def project_admin_workflow_frame(workflow, &)
    links = {
      'Data' => edit_project_admin_workflow_path(workflow.project, workflow),
      'Statuses' => edit_project_admin_workflow_statuses_path(workflow.project, workflow)
    }
    title = "Editing workflow #{workflow.name} for project #{workflow.project.name}"
    admin_frame(links, title:, back_path: project_admin_workflow_path(workflow.project, workflow), &)
  end

  def admin_frame(links, title:, back_path: nil, &)
    tabs = ProjectAdmin::TabsViewModel.new(links, id: TABS_ID, frame: FRAME_ID)
    content = capture(&) if block_given?

    render partial: 'project_admin/frame', locals: {
      id: FRAME_ID, tabs:, tabs_id: TABS_ID, title:, back_path:, content:
    }
  end
end
