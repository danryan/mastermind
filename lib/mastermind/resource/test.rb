module Mastermind
  class Resource
    class Test < Resource
      
      resource_name :test
      provider_name :test
      default_action :run
      
      attribute :message
    end
  end
end