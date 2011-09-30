module Mastermind
  class Provider
    include Mixin::Providers

    attr_accessor :new_resource
    
    provider_name :default
    actions :nothing
    
    attribute :name, String
    
    def initialize(attrs={})
      @new_resource = attrs.delete(:new_resource)
      super(attrs)
    end
    
    def self.find_by_name(name)
      Mastermind::Registry.providers[name]
    end
    
    def execute
      self.send(self.action)
    end
    
    def to_s
      "provider[#{provider_name}]"
    end
    
  end
end

