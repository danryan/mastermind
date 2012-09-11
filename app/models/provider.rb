class Provider
  attr_accessor :resource, :action

  def initialize(resource)
    @resource = resource
    @action = action
  end

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

  def as_json(options={})
    to_hash
  end
  
  def to_param
    type
  end
  
  def to_hash
    {
      type: type,
      class: self.class.name,
      options: options
      # actions: self.class.allowed_actions
    }
  end
  
  def self.register(type)
    @type = type
    Mastermind.providers[type.to_sym] = self
  end

  def self.action(action_name, &block)
    # action_name = action_name.to_sym
    # allowed_actions.push(action_name).uniq!
    define_method(action_name) do
      instance_eval(&block)
    end
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

  # we might not need this if resource validation contexts work as intended.
  
  # lovingly taken from (fog)[http://fog.io]
  # def requires(*args)
  #   missing = missing_attributes(args)
  #   if missing.length == 1
  #     raise ArgumentError, "#{missing.first} is required for this operation"
  #   elsif missing.any?
  #     raise ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation"
  #   end
  # end

  # def missing_attributes(args)
  #   missing = []
  #   args.each do |arg|
  #     unless resource.send("#{arg}") || resource.attributes.has_key?(arg.to_s) && resource[arg]
  #       missing << arg
  #     end
  #   end
  #   missing
  # end
end
