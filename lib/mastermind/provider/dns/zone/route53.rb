require 'fog'

module Mastermind
  class Provider
    class DNS 
      class Zone < DNS
        class Route53 < Zone
          provider_name :dns_zone_route53
          actions :create, :destroy, :update, :list, :show
        
          def create          
            fog = Fog::DNS.new(
              :provider => 'AWS',
              :aws_access_key_id => new_resource.access_key_id,
              :aws_secret_access_key => new_resource.secret_access_key
            )
            zone = fog.zones.create(
              :description => new_resource.description,
              :domain => new_resource.domain,
              :change_info => (new_resource.change_info || nil),
              :caller_reference => (new_resource.caller_reference || nil)
            )
          
            new_resource.update(zone.attributes)
            return new_resource
          end
        
        end
      end
    end
  end
end