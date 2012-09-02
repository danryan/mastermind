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

      server = connection(target.region).servers.create(
        image_id: target.image_id,
        flavor_id: target.flavor_id,
        groups: target.groups,
        key_name: target.key_name,
        availability_zone: target.availability_zone,
        tags: target.tags
      )
      server.wait_for { ready? }

      target.attributes = server.attributes
      target.attributes
    end

    action :destroy do
      requires :instance_id

      server = connection(target.region).servers.get(target.instance_id)
      server.destroy

      server.wait_for { state == 'terminated' }

      target.attributes = server.attributes
      target.attributes
    end

    action :stop do
      requires :instance_id

      server = connection(target.region).servers.get(target.instance_id)
      server.stop

      server.wait_for { state == 'stopped' }

      target.attributes = server.attributes
      target.attributes
    end

    action :start do
      requires :instance_id 

      server = connection(target.region).servers.get(target.instance_id)
      server.start

      server.wait_for { state == 'running' }

      target.attributes = server.attributes
      target.attributes
    end

    action :restart do
      requires :instance_id 

      server = connection(target.region).servers.get(target.instance_id)
      server.stop

      server.wait_for { state == 'stopped' }
      server.start

      server.wait_for { state == 'running' }

      target.attributes = server.attributes
      target.attributes
    end
    
    action :reboot do
      requires :instance_id 

      server = connection(target.region).servers.get(target.instance_id)
      server.reboot

      server.wait_for { state == 'running' }

      target.attributes = server.attributes
      target.attributes
    end
    
  end
end
