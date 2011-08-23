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
    
    def tasks(&block)
      if block_given?
        @tasks.instance_eval(&block)
      else
        @tasks
      end
    end
    
    def run
      tasks.each do |task|
        task.run
      end
    end
  end
end