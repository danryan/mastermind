module Mastermind
  class Resource
    module Notification
      class Email < Resource
        provider Mastermind::Provider::Notification::Email
        actions :notify
        
        attribute :subject, :type => String
        attribute :to, :type => String
        attribute :from, :type => String
        attribute :body, :type => String

        validates! :subject, :body, :from, :to,
          :presence => true,
          :on => :notify

      end
    end
  end
end
