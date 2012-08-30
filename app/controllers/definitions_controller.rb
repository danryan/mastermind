class DefinitionsController < ApplicationController
  respond_to :json
  
  def index
    @definitions = Definition.all
    respond_with @definitions
  end

  def show
    @definition = Definition.find(params[:id])
    respond_with @definition
  end

  def create
    @definition = Definition.find(params[:definition])
    if @definition.create
      flash[:notice] = "Definition created successfully."
    end
    respond_with @definition, location: definitions_url
  end

  def edit
    @definition = Definition.find(params[:id])
    respond_with @definition
  end

  def update
    @definition = Definition.find(params[:id])
    if @definition.update_attributes(params[:definition])
      flash[:notice] = "Definition updated successfully."
    end
    respond_with @definition
  end

  def destroy
    @definition = Definition.find(params[:id])
    if @definition.destroy
      flash[:notice] = "Definition destroyed successfully."
    end
    respond_with @definition
  end
end
