# frozen_string_literal: true

module ProjectAdmin
  class TabsViewModel
    include Rails.application.routes.url_helpers

    def initialize(links, id:, frame:)
      @links = links
      @id = id
      @frame = frame
    end

    def render_in(view_context)
      view_context.render(
        partial: 'project_admin/tabs',
        locals: { project: @project, id: @id, frame: @frame, links: @links }
      )
    end
  end
end
