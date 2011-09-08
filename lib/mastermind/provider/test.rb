module Mastermind
  class Provider
    class Test < Provider
      
      provider_name :test
      actions :run
      
      def run
        puts new_resource.inspect
        return new_resource
      end

    end
  end
end