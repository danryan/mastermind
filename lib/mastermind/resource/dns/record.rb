module Mastermind
  class Resource
    class DNS
      class Record < DNS
        resource_name :dns_record
        provider_name :dns
        
        default_action :create
        
        attribute :id, String
        attribute :name, String, :required => true
        attribute :value, Array, :required => true
        attribute :type, String, :required => true
        attribute :ttl, Numeric, :required => true, :numeric => true
    
      end
    end
  end
end