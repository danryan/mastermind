module Participant::Server
  class EC2 < Participant
    option :aws_access_key_id, ENV['AWS_ACCESS_KEY_ID']
    option :aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY']
    
    register :ec2_server
    
    def connection
      Fog::Compute.new(
        provider: 'AWS',
        aws_access_key_id: options[:aws_access_key_id],
        aws_secret_access_key: options[:aws_secret_access_key],
        region: params['region'] || 'us-east-1'
      )
    end

    action :create do
      requires :image_id, :flavor_id, :availability_zone, :groups, :key_name

      server = connection.servers.create(
        image_id: target.image_id,
        flavor_id: target.flavor_id,
        groups: target.groups,
        key_name: target.key_name,
        availability_zone: target.availability_zone,
        tags: target.tags
      )
      server.wait_for { ready? }

      server.attributes
    end

    action :destroy do
      requires :instance_id

      server = connection.servers.get(target.instance_id)
      server.destroy

      server.wait_for { state == 'terminated' }

      server.attributes
    end

    action :stop do
      requires :instance_id

      server = connection.servers.get(target.instance_id)
      server.stop

      server.wait_for { state == 'stopped' }

      server.attributes
    end

    action :start do
      requires :instance_id 

      server = connection.servers.get(target.instance_id)
      server.start

      server.wait_for { state == 'running' }

      server.attributes
    end

    action :restart do
      requires :instance_id 

      server = connection.servers.get(target.instance_id)
      server.stop

      server.wait_for { state == 'stopped' }
      server.start

      server.wait_for { state == 'running' }

      server.attributes
    end
    
  end
end
