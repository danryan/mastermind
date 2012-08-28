require 'mail'

module Participant::Notification
  class Email < Participant    
    option :address, ENV['SMTP_ADDRESS']
    option :port, ENV['SMTP_PORT']
    option :domain, ENV['SMTP_DOMAIN']
    option :user_name, ENV['SMTP_USER_NAME']
    option :password, ENV['SMTP_PASSWORD']
    option :authentication, ENV['SMTP_AUTH']
    option :enable_ssl, ENV['SMTP_ENABLE_SSL']
    
    register :email
    
    # Mail.defaults do
    #   delivery_method :smtp, options
    # end
    
    action :notify do
      requires :subject, :body, :from, :to
      
      # TODO
      
      {}
    end

  end
end