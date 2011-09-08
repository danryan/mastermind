module Mastermind
  class Provider
    class Test < Provider
      
      provider_name :test
      actions :run
      
      def run
        requires :foo, :bar
        
        puts "Running!"
        return new_resource
      end

      def fail
        requires :foo, :bar
        
        puts "Failing!"
        raise StandardError
        return new_resource
        
      end
      
    end
  end
end