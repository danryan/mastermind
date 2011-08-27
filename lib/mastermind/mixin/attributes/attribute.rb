module Mastermind
  module Mixin
    module Attributes
      class Attribute
        attr_accessor :name, :type, :options, :default_value
      
        def initialize(*args)
          options = args.extract_options!
          @name, @type = args.shift.to_s, args.shift
          self.options = (options || {}).symbolize_keys
          self.default_value = self.options.delete(:default)
        end
      
        def ==(other)
          @name == other.name && @type == other.type
        end
      
        def number?
          type.class.ancestors.include?(Numeric)
        end
        
        def get(value)
          if value.nil? && !default_value.nil?
            if default_value.respond_to?(:call)
              return default_value.call
            else
              return Marshal.load(Marshal.dump(default_value))
            end
          end
          
        end
        
        def set(value)
          # TODO  value.instance_of?(type)
          value.tap do |values|
            values.map! { |v| v }
          end
        end
      end
    end
  end
end