require 'fog'

module Mastermind
  class Provider
    class Server
      class EC2 < Server

        provider_name :ec2_server
        actions :create, :destroy, :stop, :start, :terminate
        
        attribute :default_action, Symbol, :default => :create
        
        def connection
          Fog::Compute.new(
            :provider => 'AWS',
            :aws_access_key_id => new_resource.aws_access_key_id,
            :aws_secret_access_key => new_resource.aws_secret_access_key
          )
        end
        
        def create          
          
          server = connection.servers.create(
            :image_id => new_resource.image_id,
            :flavor_id => new_resource.flavor_id,
            :groups => new_resource.groups,
            :key_name => new_resource.key_name,
            :availability_zone => new_resource.availability_zone
          )
          server.wait_for { ready? }
          new_resource.update(server.attributes)
          return new_resource
        end

        def destroy
          puts "Destroy!"
        end

        def stop
          puts "Stop!"
        end

        def start
          puts "Start!"
        end
        
      end
    end
  end
end