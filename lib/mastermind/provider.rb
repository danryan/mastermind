module Mastermind
  class Provider
    include Mixin::Attributes
    include Mixin::Providers

    provider_name :default
    
    actions :nothing
        
    attribute :name, String
    
    def self.find_by_name(name)
      Mastermind::Registry.providers[name]
    end
    
    def execute
      # run_validations
      self.send(self.action)
    end

  end
end

