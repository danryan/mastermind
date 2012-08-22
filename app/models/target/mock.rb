class Target::Mock < Target
  attribute :message, type: String
  
  action :pass do
    requires :message
    
    Mastermind.logger.info message
  end
  
  action :fail do
    requires :message
    
    raise StandardError, "A failing action!"
  end
end