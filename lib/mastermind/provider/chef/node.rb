module Mastermind
  class Provider
    class Chef
      class Node < Chef
      
        provider_name :chef_node
        
        actions :create, :delete, :list, :show, :reregister
        
        attribute :action, :default => :create
        attribute :run_list, :type => :array, :default => []
        
        def create
          puts "Creating chef node #{name} with run list #{run_list}"
        end
      end
    end
  end
end