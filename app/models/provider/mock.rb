class Provider
  class Mock < Provider
    
    provider_name :mock
    actions :run, :fail
    
    def run
      requires :message
      
      puts new_resource.message
      return new_resource
    end

    def fail
      requires :message
      
      raise StandardError
      return new_resource
    end
    
  end
end