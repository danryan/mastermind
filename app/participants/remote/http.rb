require 'net/ssh'

module Participant::Remote
  class HTTP < Participant
    register :http
    
    action :run do
      requires :host, :user, :key_data, :command, :output
      
      target.output = run_ssh(target.command)
      
      {}
    end

  end
end