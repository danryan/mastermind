module Mastermind
  class Provider
    class Remote 
      class SSH < Remote
        
        provider_name :ssh
        actions :connect, :disconnect, :execute
        
      end
    end
  end
end

