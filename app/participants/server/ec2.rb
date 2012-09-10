module Participant::Server
  class EC2 < Participant
    option :aws_access_key_id, ENV['AWS_ACCESS_KEY_ID']
    option :aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY']
    
    register :ec2_server
    
    def connection(region=nil)
      Fog::Compute.new(
        provider: 'AWS',
        aws_access_key_id: options[:aws_access_key_id],
        aws_secret_access_key: options[:aws_secret_access_key],
        region: (region rescue (params['region'] || 'us-east-1'))
      )
    end

    action :create do
      requires :image_id, :flavor_id, :availability_zone, :groups, :key_name

      server = connection(resource.region).servers.create(
        image_id: resource.image_id,
        flavor_id: resource.flavor_id,
        groups: resource.groups,
        key_name: resource.key_name,
        availability_zone: resource.availability_zone,
        tags: resource.tags
      )
      server.wait_for { ready? }

      resource.attributes = server.attributes
      resource.attributes
    end

    action :destroy do
      requires :instance_id

      server = connection(resource.region).servers.get(resource.instance_id)
      server.destroy

      server.wait_for { state == 'terminated' }

      resource.attributes = server.attributes
      resource.attributes
    end

    action :stop do
      requires :instance_id

      server = connection(resource.region).servers.get(resource.instance_id)
      server.stop

      server.wait_for { state == 'stopped' }

      resource.attributes = server.attributes
      resource.attributes
    end

    action :start do
      requires :instance_id 

      server = connection(resource.region).servers.get(resource.instance_id)
      server.start

      server.wait_for { state == 'running' }

      resource.attributes = server.attributes
      resource.attributes
    end

    action :restart do
      requires :instance_id 

      server = connection(resource.region).servers.get(resource.instance_id)
      server.stop

      server.wait_for { state == 'stopped' }
      server.start

      server.wait_for { state == 'running' }

      resource.attributes = server.attributes
      resource.attributes
    end
    
    action :reboot do
      requires :instance_id 

      server = connection(resource.region).servers.get(resource.instance_id)
      server.reboot

      server.wait_for { state == 'running' }

      resource.attributes = server.attributes
      resource.attributes
    end
    
  end
end
