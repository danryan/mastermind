require 'spice'
require Rails.root + 'app/participants/cm/chef'

module Participant::CM
  class Chef::Node < Chef
    
    register :chef_node
    
    action :list do
      chef_nodes = connection.get('/nodes').keys
      
      chef_nodes
    end
    
  end
end