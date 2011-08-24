require 'fog'

module Mastermind
  class Provider
    class DNS 
      class Route53 < DNS
        
        provider_name :dns_route53
        actions :create, :destroy, :update, :list, :show
        
      end
    end
  end
end