# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :fetch_project!, only: %w[show edit update destroy]

  def index
    @projects = Project.all
  end

  def show; end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def fetch_project!
    @project = Project.find_by!(code: params[:id])
  end

  def project_params
    params.expect(project: %i[code name description])
  end
end
