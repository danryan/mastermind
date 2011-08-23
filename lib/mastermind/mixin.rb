module Mastermind
  module Mixin
    
    def self.included(base)
      base.extend(Mastermind::Mixin::DSL)
    end
    
    CONFIGSORT = {
      Symbol => 0,
      String => 0,
      Regexp => 100,
    }
    
    def attributes
      @attributes
    end
    
    def set_or_get(attribute, value=nil, default=nil)
      if value
        instance_variable_set(:"@#{attribute}", value)
      else
        if instance_variable_get(:"@#{attribute}")
          instance_variable_get(:"@#{attribute}")
        else 
          instance_variable_set(:"@#{attribute}", default)
          instance_variable_get(:"@#{attribute}")
        end
      end
    end
    
    def attributes_init(params)
      # if !self.class.validate(params)
      #   puts "Validation failed."
      # end
      
      params.each do |name, value|
        opts = self.class.attributes[name]
        if opts && opts[:deprecated]
          puts "Deprecated attribute item #{name.inspect} set in #{self.class.name}"
        end
      end
      
      self.class.attributes.each do |name, opts|
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
      
      @attributes = params
    end
    
    def run_validations
      if !self.class.validate(@attributes)
        puts "Validation failed."
      end
    end
    
    
    module DSL
      
      def set_or_get(attribute, value=nil, default=nil)
        if value
          instance_variable_set(:"@#{attribute}", value)
        else
          if instance_variable_get(:"@#{attribute}")
            instance_variable_get(:"@#{attribute}")
          else 
            instance_variable_set(:"@#{attribute}", default)
            instance_variable_get(:"@#{attribute}")
          end
        end
      end
      
      def default_action(action=nil)
        @default_action = action if !action.nil?
        return @default_action
      end
      
      def provider_name(name=nil)
        @provider_name = name if !name.nil?
        Mastermind::Registry.list[@provider_name.to_sym] = self
        provider_name = @provider_name
        provider_class = Mastermind::Registry.list[@provider_name.to_sym]
         
        Mastermind::Plot.instance_eval do
          define_method provider_name do |name, &block|
            task = Task.new(:name => name)
            task.provider = provider_class
            provider = task.provider.new
            provider.name task.name
            provider.instance_eval(&block)
            task.attributes provider.attributes
            task.action task.attributes[:action]
            self.tasks << task
          end
        end
        return @provider_name
      end
      
      def actions(*args)
        @actions = args if !args.empty?
        return @actions
      end

      # Validations and attributes
      def attribute(name, params={})
        @attributes ||= Hash.new
        
        @attributes[name] = params
        
        define_method("#{name}") do |*v|
          @attributes[name] = v.first
          set_or_get("#{name}", v.first)
        end
        return @attribute
      end
      
      def inherited(subclass)
        subattributes = Hash.new
        if !@attributes.nil?
          @attributes.each do |key, value|
            subattributes[key] = value
          end
        end
        subclass.instance_variable_set("@attributes", subattributes)
        subclass.instance_variable_set("@actions", actions)
      end
      
      def attributes
        return @attributes
      end
      
      
      def get_options
        return @attributes
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
        
        @attributes.each_key do |attr_key|
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
        
        @attributes.each do |attr_key, attribute|
          next unless attribute[:required]
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
        
        attr_keys = @attributes.keys.sort do |a,b|
          CONFIGSORT[a.class] <=> CONFIGSORT[b.class]
        end
        
        params.each do |key, value|
          attr_keys.each do |attr_key|
            next unless (attr_key.is_a?(Regexp) && key =~ attr_key) ||
              (attr_key.is_a?(String) && key == attr_key)
            attr_val = @attributes[attr_key][:type]
            success, result = validate_value(value, attr_val)
            if success
              params[key] = result if !result.nil?
            else
              puts "Failed attribute #{provider_name}/#{key}: #{result} (#{value.inspect})"
            end
            is_valid &&= success
            
            break
          end
          
        end
        return is_valid
      end
      
      def validator_find(key)
        @attributes.each do |attr_key, attr_val|
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
          return false, "Unknown validator #{validator.class}"
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