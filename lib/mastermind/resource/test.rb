module Mastermind
  class Resource
    class Test < Resource
      
      resource_name :test
      provider_name :test
      default_action :run
      
      attribute :foo, String, :required => true
      attribute :bar, String
    
    end
  end
end