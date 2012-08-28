class JobsController < ApplicationController
  def index
    @job = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(params[:job])
    # render :new
    
    if @job.save
      redirect_to @job
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
