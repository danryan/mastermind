require 'tinder'

module Provider::Notification
  class Campfire < Provider    
    option :account, ENV['CAMPFIRE_ACCOUNT']
    option :room, ENV['CAMPFIRE_ROOM']
    option :token, ENV['CAMPFIRE_TOKEN']
    
    register :campfire
    
    def campfire
      Tinder::Campfire.new(options[:account], :ssl => true, :token => options[:token])
    end
    
    def room
      campfire.find_room_by_id(options[:room].to_i)
    end
    
    action :notify do
      requires :message
      
      begin
        timeout(3) do
          room.speak("#{resource.source}: #{resource.message}")
        end
      rescue Timeout::Error => e
        Mastermind.logger.error message: e.message, backtrace: e.backtrace
        raise e
      end
      
      {}
    end
    
    # action :alert do
    #   
    # end
    # 
    # action :resolve do
    #   
    # end
  end
end
