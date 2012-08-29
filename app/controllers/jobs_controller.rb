class JobsController < ApplicationController
  respond_to :html, :json
  def index
    @jobs = Job.all
    respond_with @jobs
  end

  def show
    @job = Job.find(params[:id])
    respond_with @job
  end

  def new
    @job = Job.new
    respond_with @job
  end

  def create
    @job = Job.find(params[:job])
    if @job.create
      flash[:notice] = "Job created successfully."
    end
    respond_with @job, location: jobs_url
  end

  def edit
    @job = Job.find(params[:id])
    respond_with @job
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = "Job updated successfully."
    end
    respond_with @job
  end

  def destroy
  end
  
  def launch
    @job = Job.find(params[:id])
    override_fields = params[:fields] || {}
    @job.launch(override_fields)
    respond_with @job
  end
  
  # def run
  #   @job = Job.find(params[:id])
  #   @job.run
  #   respond_with @job
  # end
  # 
  # def error
  #   @job = Job.find(params[:id])
  #   @job.run
  #   respond_with @job
  # end
  # 
  # def complete
  #   @job = Job.find(params[:id])
  #   @job.complete
  #   respond_with @job
  # end
  
  def cancel
    @job = Job.find(params[:id])
    @job.cancel
    respond_with @job
  end
  

  
end
