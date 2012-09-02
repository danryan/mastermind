require 'spice'
require Rails.root + 'app/participants/cm/chef'

module Participant::CM
  class Chef::Client < Chef
    register :chef_client
    
    action :list do
      chef_nodes = connection.get('/nodes').keys
      
      { chef_nodes: chef_nodes }
    end
    
  end
end