module Mastermind
  class Provider

    autoload :Mock, 'mastermind/provider/mock'
    autoload :Server, 'mastermind/provider/server'
    autoload :Notification, 'mastermind/provider/notification'
    autoload :Remote, 'mastermind/provider/remote'
    autoload :CM, 'mastermind/provider/cm'

    attr_accessor :resource, :action

    class << self

      def options
        @options ||= Hash.new.with_indifferent_access
      end

      def option(name, value)
        instance_variable_set("@#{name}", value)
        instance_eval <<-EOF, __FILE__, __LINE__
        def #{name}
          @#{name}
        end
        EOF
        options[name] = value
      end

      def inherited(subclass)
        options.each do |key, value|
          subclass.option key, value
        end
      end

      def type
        @type
      end

      def register(type)
        @type = type
        Mastermind.providers[type.to_sym] = self
      end

      def action(action_name, &block)
        # action_name = action_name.to_sym
        # actions.push(action_name).uniq!
        define_method(action_name) do
          instance_eval(&block)
        end
      end

    end

    def initialize(resource)
      @resource = resource
      @action = action
    end

    def options
      self.class.options
    end

    def type
      self.class.type
    end

    def as_json(options={})
      to_hash
    end

    def to_param
      type
    end

    def to_hash
      {
        :type => type,
        :class => self.class.name,
        :options => options
        # actions: self.class.actions
      }
    end

    # default "do-nothing" action. Useful for debugging and tests
    action :nothing do
      Mastermind.logger.debug "Doing nothing."
    end

    def run
      # clear out any previously encountered errors
      resource.errors.clear
      validate!

      begin
        results = self.send(action)
        Mastermind.logger.info results
      rescue => e
        Mastermind.logger.error e.message, :backtrace => e.backtrace
        raise e
      end
    end

    private

    def validate!
      resource.valid?(action.to_sym)
    end

    def update_resource_attributes(attributes)
      return if attributes.empty? || attributes.nil?
      raise ArgumentError, "attributes must be a hash" unless attributes.is_a?(Hash)
      resource.assign_attributes(attributes)
    end

    alias :updates_resource_attributes :update_resource_attributes
  end
end
