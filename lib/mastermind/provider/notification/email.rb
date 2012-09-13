require 'mail'

module Mastermind
  class Provider
    module Notification
      class Email < Provider
        option :address, ENV['SMTP_ADDRESS']
        option :port, ENV['SMTP_PORT']
        option :domain, ENV['SMTP_DOMAIN']
        option :user_name, ENV['SMTP_USER_NAME']
        option :password, ENV['SMTP_PASSWORD']
        option :authentication, ENV['SMTP_AUTH']
        option :enable_ssl, ENV['SMTP_ENABLE_SSL']

        # Mail.defaults do
        #   delivery_method :smtp, options
        # end

        action :notify do
          # TODO
        end

      end
    end
  end
end
