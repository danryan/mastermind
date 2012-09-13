module Mastermind
  class Resource
    module CM
      class Chef < Resource
        autoload :Node, 'mastermind/resource/cm/chef/node'
      end
    end
  end
end
