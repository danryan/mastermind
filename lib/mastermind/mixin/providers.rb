require 'active_model'
require 'active_support/concern'

module Mastermind
  module Mixin
    module Providers
      extend ActiveSupport::Concern
      
      included do
        extend ActiveSupport::DescendantsTracker
      end
      
      module ClassMethods
        def provider_name(provider_name=nil)
          @provider_name = provider_name.to_s if !provider_name.nil?
          Mastermind::Registry.providers[@provider_name] = self
          return @provider_name
        end
        
        def actions(*args)
          @actions = args if !args.empty?
          return @actions
        end
        
        def find_by_name(name)
          Mastermind::Registry.providers[name.to_s]
        end
      end
      
      module InstanceMethods
        def provider_name
          self.class.provider_name
        end
        
        def requires(*args)
          missing = []
          args.each do |arg|
            unless new_resource.send("#{arg}") || new_resource.options.has_key?(arg)
              missing << arg
            end
          end
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(", ")} and #{missing[-1]} are required for this operation")
          end
          
        end
      end
    
    end
  end
end