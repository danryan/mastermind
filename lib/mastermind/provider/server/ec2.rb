require 'fog'

module Mastermind
  class Provider
    class EC2
      class Server < EC2

        provider_name :ec2
        actions :create, :destroy, :stop, :start, :terminate
        
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