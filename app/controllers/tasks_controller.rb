# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_project, only: %i[create]
  before_action :load_task, only: %i[update destroy complete_task]

  def create
    @task = @project.tasks.build(task_params)
    @task.author = current_user
    @task.save
  end

  def update
    @task.update(task_params)
    @project = @task.project
  end

  def destroy
    @task.destroy
  end

  def complete_task
    @task.complete_task
  end

  private

  def task_params
    params.require(:task).permit(:body, :priority, :deadline, :completed)
  end

  def load_task
    if current_user.author_of?(Task.find(params[:id]))
      @task = Task.find(params[:id])
    else
      render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
    end
  end

  def load_project
    if current_user.author_of?(Project.find(params[:project_id]))
      @project = Project.find(params[:project_id])
    else
      render(file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false)
    end
  end
end
