class Resource
  class Server 
    class EC2 < Server
      
      default_action :create
      resource_name :ec2_server
      provider_name :ec2_server
      
      property :aws_access_key_id, String, :required => true
      property :aws_secret_access_key, String, :required => true
      property :image_id, String
      property :key_name, String
      property :ami_launch_index, Numeric
      property :availability_zone, String, :default => 'us-east-1a'
      property :region, String, :default => 'us-east-1'
      property :block_device_mapping, Object
      property :client_token, String
      property :dns_name, String
      property :groups, Object, :default => [ 'default' ]
      property :flavor_id, String
      property :instance_id, String
      property :kernel_id, String
      property :created_at, DateTime
      property :monitoring, Boolean, :default => false
      property :placement_group, String
      property :platform, String
      property :product_codes, Object
      property :private_dns_name, String
      property :private_ip_address, String
      property :public_ip_address, String
      property :ramdisk_id, String
      property :reason, String
      property :root_device_name, String
      property :root_device_type, String
      property :state, String
      property :state_reason, Object
      property :subnet_id, String
      property :tenancy, String
      property :tags, Object
      property :user_data, String
    end
    
  end
end