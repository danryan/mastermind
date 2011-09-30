module Mastermind
  class Plot
    include Mastermind::Mixin::Plots
    include Mastermind::Mixin::Persistence
    
    #attribute :id, Numeric
    attribute :name, String, :required => true
    attribute :tasks, Array, :default => []

    def execute
      tasks.each do |key, task|
        resource_class = Mastermind::Registry.resources[task['resource_name']]
        resource = resource_class.new(task.except('resource_name'))
        resource.execute(resource.action)
      end
    end
   
    def to_s
      "plot[#{name}]"
    end

  end
end
