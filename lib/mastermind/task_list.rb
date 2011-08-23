module Mastermind
  class TaskList
    include Enumerable
    
    attr_accessor :tasks
    
    def initialize
      @tasks = []
    end
    
    def length
      @tasks.length
    end
    
    def each(&block)
      @tasks.each(&block)
    end
    
    def add(task)
      # raise ArgumentError, "task must be a Task object" unless task.is_a?(Task)
      @tasks << task
    end
    
    alias_method :<<, :add
    
    def task(name, &block)
      task = Task.new(:name => name)
      if block_given?
        if block.arity == 1
          yield task
        else
          task.instance_eval(&block)
        end
      end
      add(task)
    end
    
  end
end