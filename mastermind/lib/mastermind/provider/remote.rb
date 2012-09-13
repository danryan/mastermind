module Mastermind
  class Provider
    module Remote
      autoload :HTTP, 'mastermind/provider/remote/http'
      autoload :SSH, 'mastermind/provider/remote/ssh'
      autoload :SSHMulti, 'mastermind/provider/remote/ssh_multi'
    end
  end
end