require 'spice'
require Rails.root + 'app/models/provider/cm/chef'

module Provider::CM
  class Chef::Node < Chef
    
    register :chef_node
    
    action :list do
      chef_nodes = connection.nodes
      chef_nodes
    end
    
  end
end