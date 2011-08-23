module Mastermind
  class Provider
    class EC2
      class Server < EC2

        provider_name :ec2_server
        
        actions :create, :destroy, :stop, :start, :terminate
        
        default_action :create
        
        option :availability_zone, :type => :array, :required => true
        option :flavor_id,         :type => :string, :required => true
        option :image_id,          :type => :string, :required => true
        option :key_name,          :type => :string, :required => true
        option :groups,            :type => :array
        option :user_data,         :type => :string
        option :monitoring,        :type => :boolean        
        
        def create
          puts "Create!"
          puts options.inspect
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
        
        # actions.each do |act|
        #   meth = "#{provider_name}_#{act}"
        #   Mastermind::TaskList.instance_eval <<-EOF
        #     define_method meth do |*args|
        #       puts "Hi from inside #{meth}"
        #     end
        #   EOF
        # end
        
      end
    end
  end
end