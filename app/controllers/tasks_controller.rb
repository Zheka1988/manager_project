class TasksController < ApplicationController
  before_action :authenticate_user! 
  before_action :load_project, only: [:create, :new]
  before_action :load_task, only: [:show, :edit, :update, :destroy, :complete_task]

  def show
  end

  def new
    @task = @project.tasks.new
  end

  def edit
  end

  def create
    @task = @project.tasks.build(task_params)
    @task.author = current_user
    if @task.save
      redirect_to @task, notice: 'Your task has been successfully added.'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Your task has been successfully edited."
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to project_path(@task.project)
  end

  def complete_task
    if current_user.author_of?(@task)
      @task.complete_task
      redirect_to project_path(@task.project), notice: "Task completed"
    else
      flash[:notice] = "Only author can completed task"
    end
  end

  private
  def task_params
    params.require(:task).permit(:body, :priority, :deadline, :completed )
  end

  def load_task
    if current_user.author_of?(Task.find(params[:id]))
      @task = Task.find(params[:id])
    else
      render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false) 
    end
  end

  def load_project
    @project = Project.find(params[:project_id])
  end
end
