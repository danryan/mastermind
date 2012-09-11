require 'spice'
require Rails.root + 'app/models/provider/cm/chef'

module Provider::CM
  class Chef::Client < Chef
    
    register :chef_client
    
    action :list do
      clients = connection.get('/clients').keys
      
      clients
    end
    
  end
end