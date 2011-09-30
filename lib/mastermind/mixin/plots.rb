require 'active_support/concern'

module Mastermind::Mixin::Plots
  extend ActiveSupport::Concern
  include Ascribe::Attributes
   
  included do
    extend ActiveSupport::DescendantsTracker
  end
  
  module ClassMethods
  
  end

  module InstanceMethods

    def initialize(attrs={}, &block)
      if block_given?
        if block.arity == 1
          yield self
        else
          instance_eval &block
        end
      end
      Mastermind::Registry.resources.each_pair do |key, value|
        class_eval do
          define_method key do |name, &block|
            dsl_method(name, value, &block)
          end
        end
      end
      super(attrs)
    end

    def dsl_method(name, klass, &block)
      resource = klass.new rescue Mastermind::Resource.new
      resource.name = name
      resource.action = (resource.action ? resource.action : klass.default_action)
      if block_given?
        resource.instance_eval(&block)
      end
      tasks["#{resource.resource_name}[#{resource.name}]"] = resource.options
    end

  end

end
