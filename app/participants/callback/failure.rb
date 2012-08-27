module Participant::Callback
  class Failure < Participant
    register 'failure'

    def on_workitem
      Mastermind.logger.error fields
      
      reply
    end
    
  end
end