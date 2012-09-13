module Mastermind
  class Resource
    module Server
      class EC2 < Resource
        provider Mastermind::Provider::Server::EC2
        actions :create, :destroy, :stop, :start, :restart, :reboot

        attribute :image_id, :type => String
        attribute :key_name, :type => String
        attribute :ami_launch_index, :type => Integer
        attribute :availability_zone, :type => String #, :default =>  'us-east-1a'
        attribute :block_device_mapping, :type => Object, :default =>  []
        attribute :client_token, :type => String
        attribute :dns_name, :type => String
        attribute :groups, :type => Object, :default =>  [ 'default' ]
        attribute :flavor_id, :type => String
        attribute :iam_instance_profile, :type => Object, :default =>  {}
        attribute :instance_id, :type => String
        attribute :kernel_id, :type => String
        attribute :created_at, :type => DateTime
        attribute :monitoring, :type => Boolean, :default =>  false
        attribute :network_interface, :type => Object, :default =>  []
        attribute :placement_group, :type => String
        attribute :platform, :type => String
        attribute :product_codes, :type => Object, :default =>  []
        attribute :private_dns_name, :type => String
        attribute :private_ip_address, :type => String
        attribute :public_ip_address, :type => String
        attribute :ramdisk_id, :type => String
        attribute :reason, :type => String
        attribute :region, :type => String #, :default =>  'us-east-1'
        attribute :root_device_name, :type => String
        attribute :root_device_type, :type => String
        attribute :security_group_ids, :type => Object, :default =>  []
        attribute :state, :type => String
        attribute :state_reason, :type => Object
        attribute :subnet_id, :type => String
        attribute :tenancy, :type => String
        attribute :tags, :type => Object
        attribute :user_data, :type => String
        attribute :vpc_id, :type => String

        alias_method :id, :instance_id
        alias_method :id=, :instance_id=

        validates! :image_id, :flavor_id, :availability_zone, :region, :key_name,
          :presence => true,
          :on => :create

        [ :destroy, :stop, :start, :restart, :reboot ].each do |act|
          validates! :instance_id, :region,
            :presence => true,
            :on => act
        end

        validates! :image_id,
          :format => { with: /^ami-[a-f0-9]{8}$/ },
          :allow_blank => true

        validates! :flavor_id,
          inclusion: { in: Mastermind::Mixins::AWS::FLAVORS },
          :allow_blank => true

        validates! :availability_zone,
          :if => lambda { |s| s.region? && Mastermind::Mixins::AWS::ZONES[s.region] },
          :inclusion => { in: lambda { |s| Mastermind::Mixins::AWS::ZONES[s.region] } },
          :allow_blank => true

        validates! :region,
          :inclusion => { in: Mastermind::Mixins::AWS::ZONES.keys },
          :allow_blank => true

        validates! :id, :instance_id,
          :format => { with: /^i-[a-f0-9]{8}$/ },
          :allow_blank => true

      end
    end
  end
end
