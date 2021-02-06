# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_project, only: %i[show update destroy]

  def index
    @projects = current_user.authored_projects
    @project = Project.new
  end

  def show
    @task = Task.new
  end

  def create
    @project = current_user.authored_projects.build(project_params)
    @project.save
  end

  def update
    @project.update(project_params)
  end

  def destroy
    @project.destroy
  end

  private

  def load_project
    if current_user.author_of?(Project.find(params[:id]))
      @project = Project.find(params[:id])
    else
      render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
    end
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
