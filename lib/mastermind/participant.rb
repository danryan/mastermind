module Mastermind
  class Participant
    include Ruote::LocalParticipant

    attr_accessor :resource, :provider

    def self.options
      @options ||= Hash.new.with_indifferent_access
    end

    def options
      self.class.options
    end

    def self.option(name, value)
      instance_variable_set("@#{name}", value)
      instance_eval <<-EOF, __FILE__, __LINE__
      def #{name}
        @#{name}
      end
      EOF
      options[name] = value
    end
    
    def self.inherited(subclass)
      options.each do |key, value|
        subclass.option key, value
      end
    end

    def self.type
      @type
    end

    def type
      self.class.type
    end
    
    def regex
      "^(.+)_#{type}$"
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
        :regex => regex,
        :class => self.class.name,
        :options => options,
        :actions => self.class.actions
      }
    end
    
    def self.register(type)
      @type = type
      Mastermind.dashboard.register_provider "(.+)_#{type}[s]?", self, options
      Mastermind.providers[Regexp.new("^(.+)_#{type}s?$")] = self
    end

    def on_workitem
      Mastermind.logger.debug :provider => type, :action => action, :params => params, :fields => fields

      @resource = Mastermind.resources[self.class.type].new(params)

      Mastermind.logger.debug "attributes", attributes
      Mastermind.logger.debug "fields", fields
      Mastermind.logger.debug "params", params
      
      validate!
      execute!    
      reply
    end

    def on_reply
      Mastermind.logger.debug provider: type, action: action, params: params, fields: fields
    end

    def params
      workitem.fields['params']
    end
    
    def result_field
      workitem.fields['params']['result_field']
    end
    
    def result_field?
      !!result_field
    end
    
    def fields
      workitem.fields.except('params')
    end

    def attributes
      fields.deep_merge(params)
    end

    def action
      # params['ref'].split('_').first
      params['ref'].gsub("_#{type}", '')
      # workitem.field_or_param(:action)
    end

    def self.action(action_name, options={}, &block)
      action_name = action_name.to_sym
      actions.push(action_name).uniq!

      define_method(action_name) do
        instance_eval(&block)
      end
    end

    def self.actions
      @actions ||= []
    end

    def actions
      self.class.actions
    end
    
    # default "do-nothing" action. Useful for debugging and tests
    action :nothing do
      Mastermind.logger.debug "Doing nothing."

      {}
    end
  end
end

Mastermind.dashboard.register_participant :mastermind, self