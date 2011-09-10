module Mastermind
  class Provider
    class Test < Provider
      
      provider_name :test
      actions :run
      
      def run
        requires :message
        
        puts new_resource.message
        return new_resource
      end

      def fail
        requires :message
        
        puts new_resource.message
        
        raise StandardError
        return new_resource
        
      end
      
    end
  end
end