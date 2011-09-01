module Mastermind
  class Plot
    include Mixin::Attributes
    
    attribute :name, String
    attribute :tasks, Array, :default => []
    
    def initialize(attrs={}, &block)
      if block_given?
        if block.arity == 1
          yield self
        else
          instance_eval &block
        end
      end
      super(attrs)
    end

    def execute
      tasks.each do |task|
        task.execute(task.action)
      end
    end
    
    def dsl_method(name, klass, &block)
      resource = klass.new
      resource.name name
      resource.action (resource.action ? resource.action : klass.default_action)
      resource.instance_eval(&block)
      tasks << resource
    end
    
    def dns_zone_route53(name, &block)
      dsl_method(name, Mastermind::Resource::DNS::Zone::Route53, &block)
    end
  end
end