class Participant
  include Ruote::LocalParticipant

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
  
  
  def self.register(name)
    Mastermind.dashboard.register_participant name, self, options
  end

  def on_workitem
    raise NotImplementedError, "Override #on_workitem in a subclass"
  end
  
  def params
    workitem.fields['params']
  end
  
  def fields
    workitem.fields
  end
  
  def action
    params['action']
  end
end
