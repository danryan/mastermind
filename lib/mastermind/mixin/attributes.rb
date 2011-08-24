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
            attributes[attribute.name] = attribute
            create_accessors_for(attribute)
            create_attribute_in_descendants(*args)
            create_validations_for(attribute)
          end
        end
        
        def attribute?(attribute)
          attributes.keys.include?(attribute.to_s)
        end
        
        private
                  
        def attribute_accessors_module_defined?
          if method(:const_defined?).arity == 1
            const_defined?('MastermindAttributes')
          else
            const_defined?('MastermindAttributes', false)
          end
        end
        
        def accessors_module
          if attribute_accessors_module_defined?
            const_get 'MastermindAttributes'
          else
            const_set 'MastermindAttributes', Module.new
          end
        end
        
        def create_accessors_for(attribute)
          accessors_module.module_eval <<-EVAL
            def #{attribute.name}(value=nil)
              if value
                instance_variable_set("@#{attribute.name}", value)
              else
                instance_variable_get("@#{attribute.name}")
              end
            end
            
            def #{attribute.name}=(value)
              instance_variable_set("@#{attribute.name}", value)
            end
            
            def #{attribute.name}?
              instance_variable_get("@#{attribute.name}").present?
            end
          EVAL
          
          include accessors_module
        end
          
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
        end
        
        def options=(attrs)
          return if attrs.blank?

          attrs.each_pair do |key, value|
            if respond_to?(:"#{key}=")
              self.send(:"#{key}=", value)
            else
              self[key] = value
            end
          end
        end

        def options
          HashWithIndifferentAccess.new.tap do |attrs|
            attributes.select { |name, attr| !self[attr.name].nil? }.each do |name, attr|
              value = attr.set(self[attr.name])
              attrs[name] = value
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
          self.class.attribute(name) unless respond_to?("#{name}=")
        end
        
        def read_attribute(name)
          if attribute = attributes[name.to_s]
            value = attribute.get(instance_variable_get(:"@#{name}"))
            instance_variable_set(:"@#{name}", value)
          end
        end
        
        def write_attribute(name, value)
          attribute = attributes[name.to_s]
          instance_variable_set(:"@#{name}", attribute.set(value))
        end
        
        # def requires(*args)
        #   missing = missing_attributes(args)
        #   if missing.length == 1
        #     raise(ArgumentError, "#{missing.first} is required for this operation")
        #   elsif missing.any?
        #     raise(ArgumentError, "#{missing[0...-1].join(", ")} and #{missing[-1]} are required for this operation")
        #   end
        # end
        # 
        # def missing_attributes(*args)
        #   missing = []
        #   for arg in args
        #     unless send("#{arg}") || attributes.has_key?(arg)
        #       missing << arg
        #     end
        #   end
        #   missing
        # end


      end # InstanceMethods
      
    end
  end
end