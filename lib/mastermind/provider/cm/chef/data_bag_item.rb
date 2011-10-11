require 'spice'

module Mastermind
  class Provider
    class CM 
      class Chef
        class DataBagItem < Chef
        
          provider_name :chef_data_bag_item
          actions :create, :destroy, :update, :show
        end
      end
    end
  end
end