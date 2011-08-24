require 'fog'

module Mastermind
  class Provider
    class Server 
      class Linode < Server

        provider_name :linode_server
        actions :create, :destroy, :restart

      end
    end
  end
end