# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :fetch_task, only: %w[show edit update delete]

  def index
    if params[:project]
      @project = Project.find_by!(code: params[:project])
      @tasks = @project.tasks
    else
      @tasks = Task.all
    end

    @tasks = @tasks.includes(:project)
  end

  def show; end

  private

  def fetch_task
    @task = Task.find_by_full_number_or_id!(params[:id])
  end
end
