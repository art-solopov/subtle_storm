# frozen_string_literal: true

module ProjectAdmin
  module Workflows
    class StatusesController < ApplicationController
      before_action :fetch_workflow

      def edit
        @form = ProjectAdmin::Workflows::Statuses::BatchUpdate.from_model(@workflow)
      end

      def batch_update
        form_params = params.expect(workflow: { task_statuses_attributes: [%i[id _destroy name color icon]] })

        if form_params[:task_statuses_attributes].respond_to?(:keys)
          form_params[:task_statuses_attributes] = form_params[:task_statuses_attributes].values
        end

        @form = ProjectAdmin::Workflows::Statuses::BatchUpdate.new(form_params)
        if @form.call(@workflow)
          redirect_to project_admin_workflow_path(@project, @workflow)
        else
          render :edit
        end
      end

      private

      def fetch_workflow
        @workflow = @project.workflows.find(params[:workflow_id])
      end
    end
  end
end
