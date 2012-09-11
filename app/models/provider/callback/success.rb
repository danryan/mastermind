module Provider::Callback
  class Success < Provider
    register 'success'
    
    def on_workitem
      Mastermind.logger.info fields
      reply
    end
    
  end
end