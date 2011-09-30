module Mastermind
  class Plot
    include Mastermind::Mixin::Plots
    
    attribute :id, Numeric
    attribute :name, String, :required => true
    attribute :tasks, Array, :default => []

    def execute
      tasks.each do |task|
        task.execute(task.action)
      end
    end
   
    def to_s
      "plot[#{name}]"
    end

  end
end
