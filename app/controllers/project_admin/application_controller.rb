# frozen_string_literal: true

module ProjectAdmin
  class ApplicationController < ::ApplicationController
    before_action :fetch_project

    private

    def fetch_project
      @project = Project.find_by!(code: params[:project_id])
    end
  end
end
