class TasksController < ApplicationController
  def index
    @tasks = job.tasks.all
  end

  def show
    @task = job.tasks.find(params[:id])
  end

  def new
    @task = job.tasks.new
  end

  def create
    @task = job.tasks.new(params[:task])
  end

  def edit
    @task = job.tasks.find(params[:id])
  end

  def update
  end

  def destroy
  end
  
  def run
  end
  
  def error
  end
  
  def complete
  end
  
  def cancel
  end
  
  private
  
  def job
    @job ||= Job.find(params[:job_id])
  end
  
end
