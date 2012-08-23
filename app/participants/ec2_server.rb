class Participant::EC2Server < Participant
  register :ec2_server
  
  option :aws_access_key_id, ENV['AWS_ACCESS_KEY_ID']
  option :aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY']

  def connection
    Fog::Compute.new(
      provider: 'AWS',
      aws_access_key_id: options[:aws_access_key_id],
      aws_secret_access_key: options[:aws_secret_access_key]
    )
  end
  
  def on_workitem
    Mastermind.logger.debug "Executing EC2 server workitem", params
    target = Target::Server::EC2.new(workitem.fields)
    target.execute(action)
    
    workitem.fields.merge!(target.attributes)
    Mastermind.logger.info workitem.fields
    reply
  end
  
end
