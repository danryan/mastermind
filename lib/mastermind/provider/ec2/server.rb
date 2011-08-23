require 'fog'

module Mastermind
  class Provider
    class EC2
      class Server < EC2

        provider_name :ec2_server
        
        actions :create, :destroy, :stop, :start, :terminate
        
        attribute :action,                :default => :create
        attribute :aws_access_key_id,     :type => :string, :required => true
        attribute :aws_secret_access_key, :type => :string, :required => true
        attribute :availability_zone,     :type => :array, :required => true
        attribute :flavor_id,             :type => :string, :required => true
        attribute :image_id,              :type => :string, :required => true
        attribute :key_name,              :type => :string, :required => true
        attribute :groups,                :type => :array
        attribute :user_data,             :type => :string
        attribute :monitoring,            :type => :boolean        
        attribute :instance_id,           :type => :string
        attribute :tags,                  :type => :array
        attribute :kernel_id,             :type => :string
        attribute :ami_launch_index,      :type => :number
        attribute :client_token,          :type => :string, :default => nil
        attribute :key_name,              :type => :string, :required => true
        attribute :ram_disk_id,           :type => :string
        attribute :state,                 :type => :string
        attribute :user_data,             :type => :string
        
        def create
          fog = Fog::Compute.new(
            :provider => 'AWS',
            :aws_access_key_id => attributes.delete(:aws_access_key_id),
            :aws_secret_access_key => attributes.delete(:aws_secret_access_key)
          )
          attributes.delete(:action)
          server = fog.servers.create(attributes)
          server.wait_for { ready? }
          attributes.merge!(server.attributes)
          puts self.inspect
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