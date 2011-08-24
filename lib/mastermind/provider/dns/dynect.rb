require 'fog'

module Mastermind
  class Provider
    class DNS 
      class Dynect < DNS
        
        provider_name :dynect
        actions :create, :destroy, :update, :list, :show
        
      end
    end
  end
end