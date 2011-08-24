module Mastermind
  class Provider
    class Remote 
      class HTTP < Remote
        
        provider_name :http
        actions :get, :post, :put, :delete, :head
        
      end
    end
  end
end

