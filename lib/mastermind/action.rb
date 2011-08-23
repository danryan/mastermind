module Mastermind
  class Action
    def initialize(name, &block)
      @name = name
      instance_eval(&block)
    end
    
  end
end