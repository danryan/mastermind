module Mastermind
  class Resource
    class Server 
      class EC2 < Server

        resource_name :ec2_server
        provider_name :ec2_server
        default_action :create
        
        attribute :access_key_id, String, :required => true
        attribute :secret_access_key, String, :required => true
        attribute :image_id, String
        attribute :key_name, String
        attribute :ami_launch_index, Numeric
        attribute :availability_zone, String
        attribute :region, String
        attribute :block_device_mapping, Array
        attribute :client_token, String
        attribute :dns_name, String
        attribute :groups, Array, :default => [ 'default' ]
        attribute :flavor_id, String
        attribute :instance_id, String
        attribute :kernel_id, String
        attribute :created_at, DateTime
        attribute :monitoring, String
        attribute :placement_group, String
        attribute :platform, String
        attribute :product_codes, Array
        attribute :private_dns_name, String
        attribute :private_ip_address, String
        attribute :public_ip_address, String
        attribute :ramdisk_id, String
        attribute :reason, String
        attribute :root_device_name, String
        attribute :root_device_type, String
        attribute :state, String
        attribute :state_reason, String
        attribute :subnet_id, String
        attribute :tenancy, String
        attribute :tags, Hash
        attribute :user_data, String
      end
    end
  end
end