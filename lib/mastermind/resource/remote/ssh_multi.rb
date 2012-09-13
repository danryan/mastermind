module Mastermind
  class Resource
    module Remote
      class SSHMulti < Resource
        register :ssh_multi
        provider Mastermind::Provider::Remote::SSHMulti
        actions :run

        attribute :command, :type => String
        attribute :hosts, :type => Object
        attribute :user, :type => String
        attribute :key_data, :type => String
        attribute :output, :type => String

        validates! :command, :hosts, :user, :key_data,
          :presence => true,
          :on => :run
      end
    end
  end
end
