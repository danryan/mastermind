require 'fog'

module Mastermind
  class Provider
    module Server
      autoload :EC2, 'mastermind/provider/server/ec2'
    end
  end
end