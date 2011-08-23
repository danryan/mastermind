module Mastermind
  class Plot
    include Mixin
    
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
    
    def execute
      tasks.each do |task|
        task.execute
      end
    end
  end
end