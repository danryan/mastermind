module Mastermind
  class Plot
    include Mastermind::Mixin::Attributes
    include Mastermind::Mixin::Persistence
    
    attribute :id, Numeric
    attribute :name, String, :required => true
    attribute :tasks, Hash, :default => {}

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
      super(attrs.except('tasks'))
      if attrs['tasks']
        tasks_hash = attrs['tasks'].inject({}) do |result, (k,v)|
          resource = Mastermind::Registry.resources[v['resource_name']]
          result[k] = resource.new(v.except('resource_name'))
          result
        end
        self.tasks = tasks_hash
      end
    end
    
    def execute
      tasks.each do |key, task|
        resource_class = Mastermind::Registry.resources[task['resource_name']]
        resource = resource_class.new(task.except('resource_name'))
        resource.execute(resource.action)
      end
    end
    
    def dsl_method(name, klass, &block)
      resource = klass.new rescue Mastermind::Resource.new
      resource.name = name
      resource.action = (resource.action ? resource.action : klass.default_action)
      if block_given?
        resource.instance_eval(&block)
      end
      tasks["#{resource.resource_name}[#{resource.name}]"] = resource.options
    end
    
    def to_hash
      tasks_hash = tasks.inject({}) do |result, (k,v)|
        result[k] = v.to_hash
        result
      end
      
      result = options.except(:tasks).merge("tasks" => tasks_hash)
      return result
    end
    
    def to_json(*a)
      to_hash.to_json(*a)
    end
    
    def from_json(*a)
      
    end
  end
end