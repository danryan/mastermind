module Mastermind
  class Provider
    class CM 
      class Puppet < CM
        provider_name :puppet
        actions :create, :destroy, :update, :list, :show
        
      end
    end
  end
end