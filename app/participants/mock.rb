class Participant::Mock < Participant
  register :mock
  
  action :pass do
    requires :message
    
    Mastermind.logger.info target.message
    
    {}
  end
  
  action :modify do
    requires :message
    
    Mastermind.logger.info target.message
    
    workitem.fields.merge!({ foo: "BAR!" })
  end
  
  action :fail do
    requires :message
    
    raise StandardError, "A failing action!"
    
    {}
  end

end