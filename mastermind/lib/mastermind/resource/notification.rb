module Mastermind
  class Resource
    module Notification
      autoload :Campfire, 'mastermind/resource/notification/campfire'
      autoload :Email, 'mastermind/resource/notification/email'
    end
  end
end