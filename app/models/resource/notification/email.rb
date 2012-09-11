module Resource::Notification
  class Email < Resource
    register :email

    attribute :subject, type: String
    attribute :to, type: String
    attribute :from, type: String
    attribute :body, type: String

  end
end