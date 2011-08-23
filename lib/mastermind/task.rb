module Mastermind
  class Task
    include Mixin
    
    attr_accessor :name, :action, :provider, :options
    
    def initialize(args = {})
      @name = args.delete(:name)
      @provider = args.delete(:provider)
      @action = args.delete(:action)
      @attributes = args
    end
    
    def name(value=nil)
      set_or_get(:name, value)
    end
    
    def action(value=nil)
      set_or_get(:action, value, provider.default_action)
    end
    
    def provider(value=nil)
      set_or_get(:provider, value)
    end
    
    def attributes(value=nil)
      set_or_get(:attributes, value)
    end
    
    def execute
      provider.new(attributes).send(action)
    end
  end
end
