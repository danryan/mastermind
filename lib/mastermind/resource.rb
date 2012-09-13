require 'mastermind/mixins/resources'

module Mastermind
  class Resource
    autoload :Mock, 'mastermind/resource/mock'
    autoload :Server, 'mastermind/resource/server'
    autoload :Notification, 'mastermind/resource/notification'
    autoload :Remote, 'mastermind/resource/remote'
    autoload :CM, 'mastermind/resource/cm'

    include Mastermind::Mixins::Resources
    include ActiveAttr::Model
    include ActiveAttr::TypecastedAttributes

    attribute :action, :type => String
    attribute :name, :type => String
    attribute :type, :type => String, :default =>  lambda { self.class.type }
    # attribute :provider, :type => Object, :default =>  lambda { Mastermind.providers[self.class.type] }

    self.include_root_in_json = false
  end
end
