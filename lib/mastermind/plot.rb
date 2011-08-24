module Mastermind
  class Plot
    
    attr_accessor :name, :tasks
    
    def initialize(name, &block)
      @name = name
      @tasks = TaskList.new
      if block_given?
        if block.arity == 1
          yield self
        else
          instance_eval &block
        end
      end
    end
    
    def tasks
      @tasks
    end
    
    # def execute
    #   tasks.each do |task|
    #     task.execute
    #   end
    # end
    
    def execute(resource, action)
      resource.execute(action)
    end
    
    def dsl_method(name, resource, &block)
      new_resource = resource.new
      new_resource.name = name
      new_resource.action ||= new_resource.default_action
      new_resource.instance_eval(&block)
      execute(new_resource, new_resource.action)
    end
    
    def ec2_server(name, &block)
      dsl_method(name, Mastermind::Resource::Server::EC2, &block)
    end
    
    def dns_zone_route53(name, &block)
      dsl_method(name, Mastermind::Resource::DNS::Zone::Route53, &block)
    end
  end
end