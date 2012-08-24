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
  
  def self.type
    @type
  end
  
  def self.register(type)
    @type = type
    Mastermind.dashboard.register_participant type, self, options
    Mastermind.participants[type] = self
  end

  def on_workitem
    @target = Mastermind.targets[self.class.type].new(params)
    
    Mastermind.logger.debug "Processing #{self.class.type} workitem", params
    execute(action)
    workitem.fields.merge!(target.attributes)
    reply
  end
  
  def params
    workitem.fields['params']
  end
  
  def fields
    workitem.fields
  end
  
  def merged
    fields.merge(params)
  end
  
  def action
    workitem.field_or_param(:action)
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
  
  action :nothing do
    Mastermind.logger.debug "Doing nothing."
  end
  
  private
  
  def execute(action_to_execute)
    # clear out any previously encountered errors
    target.errors.clear
    
    action_to_execute = action_to_execute.to_sym
    
    unless self.class.allowed_actions.include?(action_to_execute)
      target.errors.add(:action, "is not valid")
    end
    
    begin
      result = self.send(action_to_execute)
      target.attributes = result
    rescue => e
      Mastermind.logger.error e.message, :backtrace => e.backtrace
      target.errors.add(:exception, e.message)
      raise e
    end
  end
  
  def requires(*args)
    args.flatten!
    
    args.each do |arg|
      unless target.attributes[arg] || target.send(arg)
        target.errors.add(arg, "can't be blank") 
      end
    end
  end
end
