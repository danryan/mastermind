require 'spice'
require Rails.root + 'app/participants/cm/chef'

module Participant::CM
  class Chef::Client < Chef
    
    register :chef_client
    
    action :list do
      clients = connection.get('/clients').keys
      
      { chef_nodes: clients }
    end
    
  end
end