require 'spice'

module Provider::CM
  class Chef < Provider
    
    # Not a real provider. Just a base class to inherit from.
    
    option :server_url, ENV['CHEF_SERVER_URL']
    option :client_name, ENV['CHEF_CLIENT_NAME']
    option :client_key, ENV['CHEF_CLIENT_KEY']
    
    def connection
      Spice::Connection.new(
        server_url: options[:server_url],
        client_name: options[:client_name],
        client_key: options[:client_key]
      )
    end

  end
end