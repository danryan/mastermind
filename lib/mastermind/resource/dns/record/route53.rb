module Mastermind
  class Resource
    class DNS
      class Record 
        class Route53 < Record
        
          resource_name :route53_dns_record
          provider_name :route53_record
          
        end
      end
    end
  end
end