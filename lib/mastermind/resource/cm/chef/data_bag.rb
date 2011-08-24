module Mastermind
  class Resource
    class CM 
      class Chef
        class DataBag < Chef
          
          resource_name :chef_data_bag
          provider_name :chef

        end
      end
    end
  end
end