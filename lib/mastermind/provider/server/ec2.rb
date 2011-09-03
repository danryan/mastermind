require 'fog'

module Mastermind
  class Provider
    class Server
      class EC2 < Server

        provider_name :ec2_server
        actions :create, :destroy, :stop, :start, :terminate

        def connection
          Fog::Compute.new(
            :provider => 'AWS',
            :aws_access_key_id => new_resource.aws_access_key_id,
            :aws_secret_access_key => new_resource.aws_secret_access_key
          )
        end
        
        def create          
          requires :image_id, :flavor_id, :key_name, :availability_zone, :groups
          
          Mastermind::Log.debug
          server = connection.servers.create(
            :image_id => new_resource.image_id,
            :flavor_id => new_resource.flavor_id,
            :groups => new_resource.groups,
            :key_name => new_resource.key_name,
            :availability_zone => new_resource.availability_zone,
            :tags => new_resource.tags
          )
          server.wait_for { ready? }
          new_resource.update(server.attributes)
          return new_resource
        end

        def destroy
          requires :instance_id
          
          server = connection.servers.get(new_resource.instance_id)
          server.destroy
          Mastermind::Log.info "Destroying EC2 server #{new_resource.instance_id}"
          server.wait_for { state == 'terminated' }
          new_resource.update(server.attributes)
          return new_resource
        end

        def stop
          requires :instance_id
          
          server = connection.servers.get(new_resource.instance_id)
          server.stop
          Mastermind::Log.info "Stopping EC2 server #{new_resource.instance_id}"
          server.wait_for { state == 'stopped' }
          new_resource.update(server.attributes)
          return new_resource        
        end

        def start
          requires :instance_id
          
          server = connection.servers.get(new_resource.instance_id)
          server.start
          Mastermind::Log.info "Starting EC2 server #{new_resource.instance_id}"
          server.wait_for { state == 'running' }
          new_resource.update(server.attributes)
          return new_resource          
        end
        
        def restart
          requires :instance_id
          
          server = connection.servers.get(new_resource.instance_id)
          server.stop
          Mastermind::Log.info "Stopping EC2 server #{new_resource.instance_id}"
          server.wait_for { state == 'stopped' }
          server.start
          Mastermind::Log.info "Starting EC2 server #{new_resource.instance_id}"
          server.wait_for { state == 'running' }
          new_resource.update(server.attributes)
          return new_resource
        end
        
      end
    end
  end
end