class ProjectsController < ApplicationController
  before_action :fetch_project!, only: %w[show edit update destroy]

  def index
    @projects = Project.all
  end

  def show
  end

  def edit
  end

  def update
    if @project.update(params.expect(project: %i[code name description]))
      redirect_to @project
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def fetch_project!
    @project = Project.find_by!(code: params[:id])
  end
end
