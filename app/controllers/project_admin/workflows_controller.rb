# frozen_string_literal: true

module ProjectAdmin
  class WorkflowsController < ApplicationController
    def index
      @workflows = @project.workflows
    end
  end
end
