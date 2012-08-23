class Participant::Mock < Participant
  register :mock
  
  def on_workitem
    Mastermind.logger.info "processing workitem!"
    Mastermind.logger.info workitem.inspect
    Mastermind.logger.info workitem.fields
    
    Target::Mock.new(workitem.fields).execute(action)
    reply
  end
end