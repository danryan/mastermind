class ProcessesController < ApplicationController
  
  def index
    @processes = Mastermind.dashboard.processes
  end
  
  def create
    
    
    name = params[:name]
    id = params[:id]
    fields = params[:fields]
    variables = params[:variables]
    
    definition = Definition.where("name = ? OR id = ?", params[:name], params[:id])
    wfid = Mastermind.dashboard.launch(definition.definition, fields, variables)
    
    flash[:notice] = I18n.t('process.launched', :wfid => wfid)    
    redirect_to definitions_url
  end
  
end
