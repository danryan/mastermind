module Mastermind
  class Resource
    class Mock < Resource
      
      resource_name :mock
      provider_name :mock
      default_action :run
      
      attribute :message, String, :required => true
    end
  end
end
