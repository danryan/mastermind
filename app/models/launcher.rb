class Launcher
  attr_accessor :pdef, :fields, :variables
  
  def initialize(definition, fields, variables)
    @definition = Mastermind.definitions[definition]
    @fields = fields
    @variables = variables
  end
  
  def launch
    Mastermind.dashboard.launch(pdef, fields, variables)
  end
  
end

# Given fields in json format
# convert fields to hash
# initialize a launcher object with fields hash
# launch
# 
