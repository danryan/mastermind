module Mastermind
  class Resource
    class CM 
      class Chef
        class Client < Chef
          
          resource_name :chef_client
          provider_name :chef

        end
      end
    end
  end
end