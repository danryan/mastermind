require 'net/ssh'

module Participant::Remote
  class HTTP < Participant
    register :http
    
    action :run do
      requires :host, :user, :key_data, :command, :output
      
      resource.output = run_ssh(resource.command)
      
      {}
    end

  end
end