require 'active_model'
require 'active_support/all'

module Mastermind
  module Mixin
    module Resources
      extend ActiveSupport::Concern
      
      included do
        extend ActiveSupport::DescendantsTracker
      end
      
      module ClassMethods
        def resource_name(resource_name=nil)
          @resource_name = resource_name.to_sym if !resource_name.nil?
          Mastermind::Registry.resources[@resource_name] = self
          return @resource_name
        end
        
        def provider_name(provider_name=nil)
          @provider_name = provider_name if !provider_name.nil?
          return @provider_name
        end
        
        def provider 
          @provider = Mastermind::Registry.providers[provider_name]
          return @provider
        end
        
        def default_action(name=nil)
          @default_action = name if !name.nil?
          return @default_action
        end
        
        def find_by_name(name)
          Mastermind::Registry.resources[name]
        end
      end
      
      module InstanceMethods
        def provider(name=nil)
          @provider = self.class.provider if !name.nil?
          return @provider
        end
        
        def default_action(action=nil)
          @default_action = self.class.default_action if !action.nil?
          return @default_action
        end
        
        def resource_name
          self.class.resource_name
        end
        
        def execute_only_if(only_if)
          res = only_if.call
          unless res
            return false
          end
          true
        end

        def execute_not_if(not_if)
          res = not_if.call
          if res
            return false
          end
          true
        end
        
      end
    
    end
  end
end