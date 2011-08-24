require 'spice'

module Mastermind
  class Provider
    class CM 
      class Chef < CM
        
        provider_name :chef
        actions :create, :destroy, :update, :list, :show
        
      end
    end
  end
end