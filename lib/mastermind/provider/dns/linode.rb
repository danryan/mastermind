require 'fog'

module Mastermind
  class Provider
    class DNS 
      class Linode < DNS
        
        provider_name :dns_linode
        actions :create, :destroy, :update, :list, :show
        
      end
    end
  end
end