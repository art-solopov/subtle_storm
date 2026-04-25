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
        if @form.perform(@workflow)
          redirect_to(action: :edit_transitions)
        else
          render :edit
        end
      end

      def edit_transitions
        @form = ProjectAdmin::Workflows::Statuses::UpdateTransitions.from_model(@workflow)
      end

      def batch_update_transitions
        form_params = params.expect(workflow: [:default_status_id,
                                               { task_statuses_attributes: [[:id, { next_status_ids: [] }]] }])
        if form_params[:task_statuses_attributes].respond_to?(:keys)
          form_params[:task_statuses_attributes] = form_params[:task_statuses_attributes].values
        end

        @form = ProjectAdmin::Workflows::Statuses::UpdateTransitions.new(form_params)
        if @form.perform(@workflow)
          redirect_to project_admin_workflow_path(@project, @workflow)
        else
          render :edit_transitions
        end
      end

      private

      def fetch_workflow
        @workflow = @project.workflows.find(params[:workflow_id])
      end
    end
  end
end
