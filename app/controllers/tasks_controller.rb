# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :fetch_task, only: %w[show edit update delete]

  def index
    @project = fetch_project
    @tasks = if @project
               @project.tasks
             else
               Task.all
             end

    @tasks = @tasks.includes(:project)
  end

  def show; end

  def new
    @form = Tasks::Create.new(project_id: fetch_project&.id)
  end

  def create
    @form = Tasks::Create.new(params.expect(task: %i[project_id title description]))
    if @form.perform
      redirect_to tasks_path(project: @form.project)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @form = Tasks::Update.new(id: @task.id, title: @task.title, description: @task.description)
  end

  def update
    @form = Tasks::Update.new(params.expect(task: %i[title description]))

    if @form.perform(@task)
      redirect_to task_path(@task)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete; end

  private

  def fetch_project
    return nil if params[:project].blank?

    Project.find_by!(code: params[:project])
  end

  def fetch_task
    @task = Task.includes(:project).find_by_full_number_or_id!(params[:id])
  end
end
