require 'mastermind/mixin/attributes/attribute'
require 'active_model'
require 'active_support/all'

module Mastermind
  module Mixin
    module Attributes
      extend ActiveSupport::Concern
      include ActiveModel::Validations
      
      included do
        extend ActiveSupport::DescendantsTracker
      end

      module ClassMethods
        
        def inherited(base)
          base.instance_variable_set(:@attributes, attributes.dup)
          super
        end
        
        def attributes
          @attributes ||= {}
        end
        
        def attribute(*args)
          Attribute.new(*args).tap do |attribute|
            attributes[attribute.name.to_sym] = attribute
            create_attribute_in_descendants(*args)
            create_validations_for(attribute)
          end
          
        end
        
        def attribute?(attribute)
          attributes.keys.include?(attribute)
        end
        
        private
          
        def create_attribute_in_descendants(*args)
          descendants.each {|descendant| descendant.attribute(*args) }
        end
        
        def create_validations_for(attribute)
          name = attribute.name
          
          if attribute.options[:required]
            validates_presence_of(name)
          end
          
          if attribute.options[:numeric]
            number_options = attribute.type == Integer ? {:only_integer => true} : {}
            validates_numericality_of(name, number_options)
          end
          
          if attribute.options[:format]
            validates_format_of(name, :with => attribute.options[:format])
          end
          
          if attribute.options[:in]
            validates_inclusion_of(name, :in => attribute.options[:in])
          end
          
          if attribute.options[:not_in]
            validates_exclusion_of(name, :in => attribute.options[:not_in])
          end
          
          if attribute.options[:length]
            length_options = case attribute.type
            when Integer
              {:minimum => 0, :maximum => key.options[:length]}
            when Range
              {:within => key.options[:length]}
            when Hash
              key.options[:length]
            end
            validates_length_of(name, length_options)
          end          
          
        end
              
      end
      
      module InstanceMethods
        def initialize(attrs={})
          assign(attrs)
          self.class.attributes.each_pair do |key, attribute|
            (class << self; self; end).class_eval do
              define_method(attribute.name) do |*value, &block|
                if !block.nil?
                  write_attribute(attribute.name, block)
                elsif !value.blank?
                  write_attribute(attribute.name, value.first)
                else
                  read_attribute(attribute.name)
                end
              end
            end
          end
        end
        
        def options=(attrs)
          return if attrs.blank?

          attrs.each_pair do |key, value|
            if respond_to?(:"#{key}")
              write_attribute(key, value)
            else
              self[key.to_sym] = value
            end
          end
        end

        def options
          HashWithIndifferentAccess.new.tap do |attrs|
            attributes.select { |name, attr| !self[attr.name].nil? }.each do |name, attr|
              value = attr.set(self[attr.name.to_sym])
              attrs[name.to_sym] = value
            end
          end
        end
        
        def assign(attrs={})
          self.options = attrs
        end
        
        def update(attrs={})
          assign(attrs)
        end
        
        def option(key, value=nil)
          if value
            instance_variable_set("@#{key}", value)
          else
            instance_variable_get("@#{key}")
          end
        end
        
        def [](name)
          read_attribute(name)
        end
        
        def []=(name, value)
          ensure_attribute_exists(name)
          write_attribute(name, value)
        end
        
        def attributes
          self.class.attributes
        end
        
        def attribute_names
          attributes.keys
        end
        
        private
        
        def ensure_attribute_exists(name)
          self.class.attribute(name) unless respond_to?("#{name}")
        end
        
        def read_attribute(name)
          if attribute = attributes[name.to_sym]
            value = attribute.get(instance_variable_get(:"@#{name}"))
            instance_variable_set(:"@#{name}", value)
          end
        end
        
        def write_attribute(name, value)
          attribute = attributes[name.to_sym]
          instance_variable_set(:"@#{name}", attribute.set(value))
        end
        
      end # InstanceMethods
      
    end
  end
end