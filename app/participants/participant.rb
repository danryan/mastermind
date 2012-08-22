class Participant
  include Ruote::LocalParticipant

  def self.register(name)
    Mastermind.dashboard.register_participant name, self
  end

  def on_workitem
    raise NotImplementedError, "Override #consume in a subclass"
  end
  
  def params
    workitem.fields['params']
  end
end
