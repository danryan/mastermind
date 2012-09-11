module Resource::Notification
  class Email < Resource
    register :email

    attribute :subject, :type => String
    attribute :to, :type => String
    attribute :from, :type => String
    attribute :body, :type => String

    validates! :subject, :body, :from, :to,
      :presence => true,
      :on => :notify

  end
end