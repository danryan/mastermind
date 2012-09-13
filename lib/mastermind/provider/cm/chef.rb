require 'spice'

module Mastermind
  class Provider
    module CM
      class Chef < Provider
        autoload :Client, 'mastermind/provider/cm/chef/client'
        autoload :Node, 'mastermind/provider/cm/chef/node'

        # Not a real provider. Just a base class to inherit from.

        option :server_url, ENV['CHEF_SERVER_URL']
        option :client_name, ENV['CHEF_CLIENsT_NAME']
        option :client_key, ENV['CHEF_CLIENT_KEY']

        def connection
          Spice::Connection.new(
            :server_url => options[:server_url],
            :client_name => options[:client_name],
            :client_key => options[:client_key]
          )
        end

      end
    end
  end
end
