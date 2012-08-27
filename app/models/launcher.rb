class Launcher
  include Celluloid
  
  attr_accessor :definition, :fields, :variables, :pdef, :wfid
  
  def initialize(definition, fields, variables)
    @definition = Definition.find(definition)
    @pdef = @definition.pdef
    @fields = fields
    @variables = variables
    @wfid = nil
  end
  
  def launch
    wfid = Mastermind.dashboard.launch(pdef, fields, variables)
    
  end
  
end

# Given fields in json format
# convert fields to hash
# initialize a launcher object with fields hash
# launch
# 
