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
    
    # return a random hash
    { foo: "BAR!", baz: "WAT!" }
  end
  
  action :fail do
    requires :message
    
    raise StandardError, "A failing action!"
    
    {}
  end

end
