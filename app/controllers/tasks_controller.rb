class TasksController < ApplicationController
  before_action :load_project, only: [:index, :create]
  before_action :load_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = @project.tasks
  end

  def show  
  end

  def new
    @task = Task.new
  end

  def edit   
  end

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to @task
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to project_tasks_path(@task.project)
  end

  private
  def task_params
    params.require(:task).permit(:body, :priority, :deadline, :completed )
  end

  def load_task
    @task = Task.find(params[:id])
  end

  def load_project
    @project = Project.find(params[:project_id])
  end
end
