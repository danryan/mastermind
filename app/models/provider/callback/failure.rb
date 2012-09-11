module Provider::Callback
  class Failure < Provider
    register 'failure'

    def on_workitem
      Mastermind.logger.error fields
      
      reply
    end
    
  end
end