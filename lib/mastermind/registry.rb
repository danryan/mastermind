module Mastermind
  class Registry
    @list = Hash.new
    
    class << self
      attr_accessor :list
    end
    
    
  end
end