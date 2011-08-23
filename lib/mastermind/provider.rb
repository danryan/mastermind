module Mastermind
  class Provider
    include Mixin

    def initialize(options={})
      options_init(options)
    end

    @registry = Hash.new

    class << self
      attr_accessor :registry
    end

  end
end


