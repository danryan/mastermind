class DefinitionsController < ApplicationController
  def index
    @definitions = Definition.all
  end

  def show
    @definition = Definition.find(params[:id])
  end

  def new
    @definition = Definition.new
  end

  def create
    # @definition = Definition.new(definition: Ruote::Reader.read(params['definition']))
    # if @definition.save
    #   redirect_to definitions_url
    # else
    #   render :new
    # end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
