require 'spice'
require Rails.root + 'app/participants/cm/chef'

module Participant::CM
  class Chef::Node < Chef
    option :server_url, ENV['CHEF_SERVER_URL']
    option :client_name, ENV['CHEF_CLIENT_NAME']
    option :client_key, Spice.read_key_file(File.expand_path(ENV['CHEF_CLIENT_KEY']))
    
    register :chef_node
    
    action :list do
      chef_nodes = connection.get('/nodes').keys
      
      { chef_nodes: chef_nodes }
    end
    
  end
end