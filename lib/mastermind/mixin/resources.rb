require 'active_support/concern'

module Mastermind::Mixin::Resources

  extend ActiveSupport::Concern
  include Ascribe::Attributes

  included do
    extend ActiveSupport::DescendantsTracker
  end
  
  module ClassMethods
    def resource_name(resource_name=nil)
      @resource_name = resource_name.to_s if !resource_name.nil?
      Mastermind::Registry.resources[@resource_name] = self
      attribute :resource_name, [String, Symbol], :default => @resource_name
      return @resource_name
    end
    
    def provider_name(provider_name=nil)
      @provider_name = provider_name.to_s if !provider_name.nil?
      attribute :provider_name, [String, Symbol], :default => @provider_name
      return @provider_name
    end
    
    def provider 
      @provider = Mastermind::Registry.providers[provider_name]
      return @provider
    end
    
    def default_action(name=nil)
      @default_action = name if !name.nil?
      attribute :default_action, [String, Symbol], :default => @default_action
      return @default_action
    end
    
    def find_by_name(name)
      Mastermind::Registry.resources[name]
    end
    
    def dsl_method(name, resource, &block)
      new_resource = resource.new
      new_resource.name name
      new_resource.action ( new_resource.action || new_resource.default_action)
      new_resource.instance_eval(&block)
      tasks << new_resource
    end

  end
  
  module InstanceMethods
    
    def execute_only_if(only_if)
      res = instance_eval { only_if.call }
      unless res
        return false
      end
      true
    end

    def execute_not_if(not_if)
      res = instance_eval { not_if.call }
      if res
        return false
      end
      true
    end

  end

end
