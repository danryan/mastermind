require 'fog'

module Mastermind
  class Provider
    class Server 
      class Rackspace < Server
        
        provider_name :rackspace
        actions :create, :destroy, :restart
        
      end
    end
  end
end