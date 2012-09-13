module Mastermind
  class Resource
    module Remote
      autoload :HTTP, 'mastermind/resource/remote/http'
      autoload :SSH, 'mastermind/resource/remote/ssh'
      autoload :SSHMulti, 'mastermind/resource/remote/ssh_multi'
    end
  end
end