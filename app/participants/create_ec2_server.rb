class Participant::CreateEC2Server < Participant
  register :create_ec2_server
  
  def on_workitem
    Mastermind.logger.info "Creating EC2 server", params
    server = Target::Server::EC2.new(params)
    server.execute(:create)
  end
end