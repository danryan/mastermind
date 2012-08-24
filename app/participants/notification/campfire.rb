module Participant::Notification
  class Campfire < Participant    
    option :account, ENV['CAMPFIRE_ACCOUNT']
    option :room, ENV['CAMPFIRE_ROOM']
    option :token, ENV['CAMPFIRE_TOKEN']
    
    register :campfire
    
    action :notice do
      
    end
    
    action :alert do
      
    end
    
    action :resolve do
      
    end
  end
end