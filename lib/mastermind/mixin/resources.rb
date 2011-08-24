require 'active_model'
require 'active_support/all'

module Mastermind
  module Mixin
    module Resources
      extend ActiveSupport::Concern
      
      included do
        # extend ActiveSupport::DescendantsTracker
      end
      
      module ClassMethods
        def resource_name(name=nil)
          @resource_name = name if !name.nil?
          Mastermind::Registry.resources[@resource_name.to_sym] = self
          return @resource_name
        end
        
        def provider(provider)
          @provider = provider if !args.blank?
          return @provider
        end
        
        def find_by_name(name)
          Mastermind::Registry.resources[name]
        end
      end
      
      module InstanceMethods
      end
    
    end
  end
end