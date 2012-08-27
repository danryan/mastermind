module Participant::Callback
  class Success < Participant
    register 'success'
    
    def on_workitem
      Mastermind.logger.info fields
      reply
    end
    
  end
end