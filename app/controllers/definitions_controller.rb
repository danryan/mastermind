class DefinitionsController < ApplicationController
  respond_to :json
  
  def index
    @definitions = Mastermind.definitions
    respond_with @definitions
  end

  def show
    @definition = Mastermind.definition(params[:id])
    respond_with @definition
  end

  # not yet implemented
  #
  # def new
  #   @definition = Definition.new
  # end
  # 
  # def create
  # end
  # 
  # def edit
  # end
  # 
  # def update
  # end
  # 
  # def destroy
  # end
end
