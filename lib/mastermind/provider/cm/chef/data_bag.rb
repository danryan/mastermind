require 'spice'

module Mastermind
  class Provider
    class CM 
      class Chef
        class DataBag < Chef
        
          provider_name :chef_data_bag
          actions :create, :destroy, :update, :list, :show
        end
      end
    end
  end
end