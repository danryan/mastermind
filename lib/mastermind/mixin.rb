module Mastermind
  module Mixin
    
    def self.included(base)
      base.extend(Mastermind::Mixin::DSL)
    end
    
    def set_or_get(option, value=nil, default=nil)
      if value
        instance_variable_set(:"@#{option}", value)
      else
        if instance_variable_get(:"@#{option}")
          instance_variable_get(:"@#{option}")
        else 
          instance_variable_set(:"@#{option}", default)
          instance_variable_get(:"@#{option}")
        end
      end
    end
    
    CONFIGSORT = {
      Symbol => 0,
      String => 0,
      Regexp => 100,
    }
  
    def options
      @options
    end
    
    def options_init(params)
      if !self.class.validate(params)
        puts "Validation failed."
      end
      
      params.each do |name, value|
        opts = self.class.options[name]
        if opts && opts[:deprecated]
          puts "Deprecated option item #{name.inspect} set in #{self.class.name}"
        end
      end
      
      self.class.options.each do |name, opts|
        next if params.include?(name)
        if opts.include?(:default) and (name.is_a?(Symbol) or name.is_a?(String))
          default = opts[:default]
          if default.is_a?(Array) or default.is_a?(Hash)
            default = default.clone
          end
          params[name] = default
        end
      end
      
      params.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      
      @options = params
      
    end
    
    
    module DSL
      
      def default_action(action=nil)
        @default_action = action if !action.nil?
        return @default_action
      end
      
      def provider_name(name=nil)
        @provider_name = name if !name.nil?
        Mastermind::Provider.registry[@provider_name.to_sym] = self
        return @provider_name
      end
      
      def actions(*args)
        @actions = args if !args.empty?
        return @actions
      end
      
      # def action(name, options, &block)
      #   Mastermind::Action.new(name, options, &block)
      # end
      
      # Validations and options
      def option(name, options={})
        @options ||= Hash.new
        
        @options[name] = options
        
        define_method(name) { instance_variable_get("@#{name}") }
        define_method("#{name}=") { |v| instance_variable_set("@#{name}", v) }
      end
      
      def inherited(subclass)
        suboptions = Hash.new
        if !@options.nil?
          @options.each do |key, value|
            suboptions[key] = val
          end
        end
        subclass.instance_variable_set("@options", suboptions)
      end
      
      def options
        return @options
      end
      
      
      def get_otions
        return @options
      end
      
      def validate(params)
        is_valid = true
        
        is_valid &&= validate_check_invalid_parameter_names(params)
        is_valid &&= validate_check_required_parameter_names(params)
        is_valid &&= validate_check_parameter_values(params)
        
        return is_valid
      end
      
      def validate_check_invalid_parameter_names(params)
        invalid_params = params.keys
        
        is_valid = true
        
        @options.each_key do |attr_key|
          if attr_key.is_a?(Regexp)
            invalid_params.reject! { |k| k =~ attr_key }
          elsif attr_key.is_a?(String) || attr_key.is_a?(Symbol)
            invalid_params.reject! { |k| k == attr_key }
          end
        end
        
        if invalid_params.size > 0
          invalid_params.each do |name|
            puts "Unknown setting '#{name}' for #{provider_name}"
          end
          is_valid = false
        end
        return is_valid
      end
      
      def validate_check_required_parameter_names(params)
        is_valid = true
        
        @options.each do |attr_key, option|
          next unless option[:required]
          
          if attr_key.is_a?(Regexp)
            next if params.keys.select { |k| k =~ attr_key }.length > 0
          elsif attr_key.is_a?(String) || attr_key.is_a?(Symbol)
            next if params.keys.include?(attr_key)
          end
          puts "Missing required parameter '#{attr_key}' for '#{provider_name}'"
          is_valid = false
        end
        
        return is_valid
      end
      
      def validate_check_parameter_values(params)
        is_valid = true
        
        attr_keys = @options.keys.sort do |a,b|
          CONFIGSORT[a.class] <=> CONFIGSORT[b.class]
        end
        
        params.each do |key, value|
          attr_keys.each do |attr_key|
            next unless (attr_key.is_a?(Regexp) && key =~ attr_key) ||
              (attr_key.is_a?(String) && key == attr_key)
            attr_val = @options[attr_key][:type]
            success, result = validate_value(value, attr_val)
            if success
              params[key] = result if !result.nil?
            else
              puts "Failed option #{provider_name}/#{key}: #{result} (#{value.inspect})"
            end
            is_valid &&= success
            
            break
          end
          
        end
        return is_valid
      end
      
      def validator_find(key)
        @options.each do |attr_key, attr_val|
          if (attr_key.is_a?(Regexg) && key =~ attr_key) || (attr_key.is_a?(String) && key == attr_key)
            return attr_val
          end
        end
        return nil
      end
      
      def validate_value(value, validator)
        
        result = nil
        
        if validator.nil?
          return true
        elsif validator.is_a?(Proc)
          return validator.call(value)
        elsif validator.is_a?(Array)
          if value.size > 1
            return false, "Expected one of #{validator.inspect}, got #{value.inspect}"
          end
          
          if !validator.include(value.first)
            return false, "Expected one of #{validator.inspect}, got #{value.inspect}"
          end
          result = value.first
        elsif validator.is_a?(Symbol)
          case validator
          when :hash
            if value.size % 2 == 1
              return false, "This field must contain an even number of items, got #{value.size}"
            end
            result = Hash[*value]
          when :array
            result = value
          when :string
            if value.size > 1
              return false, "Expected string, got #{value.inspect}"
            end
            result = value.first
          when :number
            if value.size > 1 # only one value wanted
              return false, "Expected number, got #{value.inspect}"
            end
            if value.first.to_s.to_i.to_s != value.first.to_s
              return false, "Expected number, got #{value.first.inspect}"
            end
            result = value.first.to_i
          when :boolean
            if value.size > 1 # only one value wanted
              return false, "Expected boolean, got #{value.inspect}"
            end

            if value.first !~ /^(true|false)$/
              return false, "Expected boolean 'true' or 'false', got #{value.first.inspect}"
            end

            result = (value.first == "true")
          end
        else
          return valse, "Unknown validator #{validator.class}"
        end
        
        return true, result
      end      
      
      # def action(sym, *args, &block)
      #         # self.class.send(:define_method, sym, *args, &block)
      #         if self.actions.include?(sym)
      #           self.class.class_eval do
      #             define_method sym do
      #               instance_eval &block
      #             end
      #             
      #           end
      #         else
      #           raise NoMethodError, "#{self}##{sym.to_s} is not a valid action"
      #         end
      #       end

    end
  end
end