# frozen_string_literal: true

module ProjectAdmin
  class WorkflowsController < ApplicationController
    before_action :fetch_workflow, only: %w[show edit update destroy]

    def index
      @workflows = @project.workflows
    end

    def show
      # TODO: add loading statuses and other things
    end

    def new
      @workflow = @project.workflows.build
    end

    def create
      @workflow = @project.workflows.build(workflow_params)
      if @workflow.save
        redirect_to project_admin_workflow_path(@project, @workflow)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @workflow.update(workflow_params)
        redirect_to project_admin_workflow_path(@project, @workflow)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
    end

    private

    def fetch_workflow
      @workflow = @project.workflows.find(params[:id])
    end

    def workflow_params
      params.expect(workflow: %i[name color icon])
    end
  end
end
