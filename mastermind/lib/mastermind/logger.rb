require 'cabin'

module Mastermind
  class Logger < Cabin::Channel
    
    def initialize(*args)
      super()
      
      subscribe(args[0])
      
      metrics.channel = Cabin::Channel.new
    end
  end
end