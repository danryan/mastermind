module Mastermind
  class Resource
    class CM 
      class Chef
        class Node < Chef
          
          resource_name :chef_node
          provider :chef

        end
      end
    end
  end
end