# frozen_string_literal: true

module ProjectAdmin
  class TabsViewModel
    include Rails.application.routes.url_helpers

    def initialize(project, id:, frame:)
      @project = project
      @id = id
      @frame = frame
    end

    def render_in(view_context)
      view_context.render(
        partial: 'project_admin/tabs',
        locals: { project: @project, links:, id: @id, frame: @frame }
      )
    end

    private

    def links
      {
        'Data' => edit_project_path(@project),
        'Workflows' => project_workflows_path(@project)
      }
    end
  end
end
