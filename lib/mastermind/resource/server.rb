module Mastermind
  class Resource
    class Server < Resource
      
      resource_name :server
      
      attribute :server, :type => String
    end
  end
end