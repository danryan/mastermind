module Mastermind
  class Resource
    class CM 
      class Chef
        class Environment < Chef
          
          resource_name :chef_environment
          provider :chef

        end
      end
    end
  end
end