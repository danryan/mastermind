module Mastermind
  class Provider
    module Notification
      autoload :Campfire, 'mastermind/provider/notification/campfire'
      autoload :Email, 'mastermind/provider/notification/email'
    end
  end
end