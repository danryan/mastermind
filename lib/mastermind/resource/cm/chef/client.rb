module Mastermind
  class Resource
    class CM 
      class Chef
        class Client < Chef
          
          resource_name :chef_client
          provider :chef

        end
      end
    end
  end
end