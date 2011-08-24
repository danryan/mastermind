module Mastermind
  class Resource
    class DNS
      class Zone 
        class Route53 < Zone
        
          resource_name :dns_zone_route53
          provider_name :dns_zone_route53
          
          attribute :access_key_id, String, :required => true
          attribute :secret_access_key, String, :required => true
          attribute :change_info, String
          attribute :caller_reference, String
          
        end
      end
    end
  end
end