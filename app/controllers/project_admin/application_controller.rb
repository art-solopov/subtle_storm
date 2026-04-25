# frozen_string_literal: true

module ProjectAdmin
  class ApplicationController < ::ApplicationController
    before_action :fetch_project

    private

    def fetch_project
      @project = Project.find_by!(code: params[:project_id])
      self.current_project = @project
    end
  end
end
