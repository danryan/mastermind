require 'net/ssh'

module Provider::Remote
  class HTTP < Provider
    register :http
    
    action :run do
      requires :host, :user, :key_data, :command, :output
      
      resource.output = run_ssh(resource.command)
      
      {}
    end

  end
end