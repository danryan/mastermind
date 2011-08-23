module Mastermind
  class Provider
    class EC2
      class Server < EC2

        provider_name :ec2_server
        
        actions :create, :destroy, :stop, :start, :terminate
        
        # default_action :create
        attribute :action, :default => :create
        attribute :availability_zone, :type => :array, :required => true
        attribute :flavor_id,         :type => :string, :required => true
        attribute :image_id,          :type => :string, :required => true
        attribute :key_name,          :type => :string, :required => true
        attribute :groups,            :type => :array
        attribute :user_data,         :type => :string
        attribute :monitoring,        :type => :boolean        
        
        def create
          puts "Create!"
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