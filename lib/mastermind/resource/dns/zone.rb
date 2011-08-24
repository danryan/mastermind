module Mastermind
  class Resource
    class DNS
      class Zone < DNS
        resource_name :dns_zone
        default_action :create
        
        attribute :id, String
        attribute :description, String
        attribute :domain, String, :required => true
        attribute :nameservers
    
      end
    end
  end
end