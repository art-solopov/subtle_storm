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

    def edit
      @form = ProjectAdmin::Workflows::Update.new(
        @workflow.attributes.slice('name', 'icon', 'color')
      )
    end

    def update
      @form = ProjectAdmin::Workflows::Update.new(params.expect(workflow: %i[name color icon]))

      if @form.perform(@workflow)
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
  end
end
