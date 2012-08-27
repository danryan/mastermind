require 'net/ssh'

module Participant::Remote
  class SSH < Participant
    register :ssh
    
    action :run do
      requires :host, :user, :key_data, :command, :output
      
      target.output = run_ssh(target.command)
      
      {}
    end

    def run_ssh(command)
      session = Net::SSH.start(target.host, target.user, { key_data: target.key_data })
      output = nil

      session.open_channel do |ch|
        ch.request_pty
        ch.exec command do |ch, success|
          raise ArgumentError, "Cannot execute #{command}" unless success
          ch.on_data do |ichannel, data|
            output = data
          end
        end
      end

      session.loop
      session.close
      return output if output
    end

    def tcp_test_ssh(hostname)
      tcp_socket = TCPSocket.new(hostname, 22)
      readable = IO.select([tcp_socket], nil, nil, 5)
      if readable
        Mastermind.logger.debug("sshd accepting connections on #{hostname}, banner is #{tcp_socket.gets}")
        yield
        true
      else
        false
      end
    rescue SocketError
      sleep 2
      false
    rescue Errno::ETIMEDOUT
      false
    rescue Errno::EPERM
      false
    rescue Errno::ECONNREFUSED
      sleep 2
      false
      # This happens on EC2 quite often
    rescue Errno::EHOSTUNREACH
      sleep 2
      false
    ensure
      tcp_socket && tcp_socket.close
    end
  end
end