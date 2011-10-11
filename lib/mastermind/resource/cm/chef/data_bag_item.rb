module Mastermind
  class Resource
    class CM 
      class Chef
        class DataBagItem < Chef
          
          resource_name :chef_data_bag_item
          provider_name :chef_data_bag_item
          
          attribute :bag, String
          attribute :id, String
          attribute :data, Hash

        end
      end
    end
  end
end