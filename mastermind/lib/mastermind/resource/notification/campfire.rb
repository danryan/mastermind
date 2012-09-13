module Mastermind
  class Resource
    module Notification
      class Campfire < Resource
        provider Mastermind::Provider::Notification::Campfire
        actions :notify

        attribute :message, :type => String
        attribute :source, :type => String, :default => 'mastermind'
        attribute :message_id, :type => String
        attribute :message_type, :type => String

        validates! :message,
          :presence => true,
          :on => :notify

      end
    end

  end
end
