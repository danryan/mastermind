class Provider::Mock < Provider
  register :mock
  
  action :pass do
    Mastermind.logger.info resource.message
  end
  
  action :modify do
    Mastermind.logger.info resource.message
    
    updates_resource_attributes message: "Message changed!!"
  end
  
  action :fail do
    raise StandardError, "A failing action!"
  end

end
