module Mastermind
  class Provider
    module CM
      class Chef::Client < Chef

        register :chef_client

        action :list do
          clients = connection.get('/clients').keys

          update_resource_attributes({ :clients => clients })
        end

      end
    end
  end
end
