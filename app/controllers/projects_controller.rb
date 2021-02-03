class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.authored_projects
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = current_user.authored_projects.build(project_params)
    if @project.save
      redirect_to @project, notice: "Your project successfully created."
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
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
