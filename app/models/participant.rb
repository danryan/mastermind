class Participant
  include Ruote::LocalParticipant

  attr_accessor :target

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
      type: type,
      regex: regex,
      class: self.class.name,
      options: options,
      actions: self.class.allowed_actions
    }
  end
  
  def self.register(type)
    @type = type
    Mastermind.dashboard.register_participant "(.+)_#{type}", self, options
    Mastermind.participants[Regexp.new("^(.+)_#{type}$")] = self
  end

  def on_workitem
    Mastermind.logger.debug participant: type, action: action, params: params, fields: fields

    @target = Mastermind.targets[self.class.type].new(params)

    Mastermind.logger.debug "attributes", attributes
    Mastermind.logger.debug "fields", fields
    Mastermind.logger.debug "params", params
    
    validate!
    execute!    
    reply
  end

  def on_reply
    Mastermind.logger.debug participant: type, action: action, params: params, fields: fields
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
    params['ref'].split('_').first
    # workitem.field_or_param(:action)
  end

  def self.action(action_name, options={}, &block)
    action_name = action_name.to_sym
    allowed_actions.push(action_name).uniq!

    define_method(action_name) do
      instance_eval(&block)
    end
  end

  def self.allowed_actions
    @allowed_actions ||= []
  end

  def allowed_actions
    self.class.allowed_actions
  end
  
  # default "do-nothing" action. Useful for debugging and tests
  action :nothing do
    Mastermind.logger.debug "Doing nothing."

    {}
  end

  private

  def validate!
    target.valid?
  end
  
  def execute!
    # clear out any previously encountered errors
    target.errors.clear

    action_to_execute = action.to_sym

    begin
      results = self.send(action_to_execute)
      if result_field?
        workitem.fields[result_field] = results
      else
        workitem.fields.merge!(results)
      end
    rescue => e
      Mastermind.logger.error e.message, :backtrace => e.backtrace
      raise e
    end
  end
  
  
  # lovingly taken from (fog)[http://fog.io]
  def requires(*args)
    missing = missing_attributes(args)
    if missing.length == 1
      raise ArgumentError, "#{missing.first} is required for this operation"
    elsif missing.any?
      raise ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation"
    end
  end

  def missing_attributes(args)
    missing = []
    args.each do |arg|
      unless target.send("#{arg}") || target.attributes.has_key?(arg.to_s) && target[arg]
        missing << arg
      end
    end
    missing
  end
end
