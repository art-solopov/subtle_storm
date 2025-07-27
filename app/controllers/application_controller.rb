# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :all_projects, :current_project

  private

  # Needed in projects selector (and can be used anywhere else)
  def all_projects
    Project.order(:name)
  end

  attr_accessor :current_project
end
