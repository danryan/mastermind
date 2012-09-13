module Mastermind
  class Provider
    module CM
      class Chef::Node < Chef
        action :list do
          chef_nodes = connection.nodes
          chef_nodes
        end

      end
    end
  end
end
