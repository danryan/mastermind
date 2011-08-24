require 'fog'

module Mastermind
  class Provider
    class DNS 
      class DNSimple < DNS
        
        provider_name :dns_dnsimple
        actions :create, :destroy, :update, :list, :show
        
      end
    end
  end
end