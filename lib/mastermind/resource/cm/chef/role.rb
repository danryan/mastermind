module Mastermind
  class Resource
    class CM 
      class Chef
        class Role < Chef
          
          resource_name :chef_role
          provider :chef

        end
      end
    end
  end
end