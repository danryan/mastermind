module Mastermind
  class Resource
    module CM
      class Chef::Node < Chef
        provider Mastermind::Provider::CM::Chef::Node
        actions :list, :show, :create, :update, :delete
        
        attribute :run_list, :type => Object, :default =>  []
        attribute :automatic, :type => Object, :default =>  {}
        attribute :default, :type => Object, :default =>  {}
        attribute :normal, :type => Object, :default =>  {}
        attribute :override, :type => Object, :default =>  {}
        attribute :_rev, :type => String
        attribute :chef_type, :type => String, :default =>  "node"
        attribute :json_class, :type => String, :default =>  "Chef::Node"

      end
    end
  end
end
