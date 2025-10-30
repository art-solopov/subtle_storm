# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :fetch_task, only: %w[show edit update delete]

  def index
    self.current_project = fetch_project
    @tasks = if current_project
               current_project.tasks
             else
               Task.all
             end

    @tasks = @tasks.includes(:project, :status)
  end

  def show; end

  def new
    @project = fetch_project || Project.order(:name).first
    @form = Tasks::Create.new(project_id: @project.id)
  end

  def create
    @form = Tasks::Create.new(params.expect(task: %i[project_id title description status_id]))
    if @form.perform
      redirect_to tasks_path(project: @form.project)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @form = Tasks::Update.new(@task.attributes.slice(*Tasks::Update.attribute_names))
  end

  def update
    @form = Tasks::Update.new(params.expect(task: %i[title description status_id]))

    if @form.perform(@task)
      redirect_to task_path(@task)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @task.destroy!
    redirect_to tasks_path(project: @task.project)
  end

  private

  def fetch_project
    return nil if params[:project].blank?

    Project.find_by!(code: params[:project])
  end

  def fetch_task
    @task = Task.includes(:project).find_by_full_number_or_id!(params[:id])
    self.current_project = @task.project
  end
end
