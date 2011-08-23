module Mastermind
  class Provider
    class Chef
      class Client < Chef
      
        provider_name :chef_client
        
        actions :create, :delete, :list, :show, :reregister
        
        attribute :action, :default => :create
        attribute :admin, :type => :boolean, :default => false
        attribute :private_key, :type => :string
        
        def create
          puts "Creating chef client #{name}"
        end
      end
    end
  end
end