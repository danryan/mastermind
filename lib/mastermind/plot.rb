module Mastermind
  class Plot
    include Mastermind::Mixin::Attributes
    
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
      Mastermind::Registry.resources.each_pair do |key, value|
        class_eval do
          define_method key do |name, &block|
            dsl_method(name, value, &block)
          end
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
      resource = klass.new rescue Mastermind::Resource.new
      resource.name name
      resource.action (resource.action ? resource.action : klass.default_action)
      if block_given?
        resource.instance_eval(&block)
      end
      tasks << resource
    end
    
  end
end