require 'active_model'
require 'active_support/all'

module Mastermind
  module Mixin
    module Providers
      extend ActiveSupport::Concern
      
      included do
        extend ActiveSupport::DescendantsTracker
      end
      
      module ClassMethods
        def provider_name(provider_name=nil)
          @provider_name = provider_name.to_sym if !provider_name.nil?
          Mastermind::Registry.providers[@provider_name] = self
          return @provider_name
        end
        
        def actions(*args)
          @actions = args if !args.empty?
          return @actions
        end
        
        def find_by_name(name)
          Mastermind::Registry.providers[name]
        end
      end
      
      module InstanceMethods
      end
    
    end
  end
end