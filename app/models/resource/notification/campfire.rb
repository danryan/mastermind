module Resource::Notification
  class Campfire < Resource
    register :campfire

    attribute :message, :type => String
    attribute :source, :type => String, :default => 'mastermind'
    attribute :message_id, :type => String
    attribute :message_type, :type => String

    validates! :message,
      :presence => true,
      :on => :notify
  end
end
