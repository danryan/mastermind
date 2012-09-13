require 'json'
require 'cabin'

require 'active_support/json'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/hash/conversions'
require 'active_support/core_ext/hash/indifferent_access'

require 'fog'
require 'tinder'
require 'net/ssh'
require 'net/ssh/multi'
require 'spice'
require 'faraday'
require 'addressable/uri'
require 'active_attr'

# require 'state_machine'

module Mastermind
  autoload :JobObserver,  'mastermind/job_observer'
  autoload :Logger,       'mastermind/logger'
  autoload :Mixins,       'mastermind/mixins'
  autoload :Registry,     'mastermind/registry'
  autoload :Resource,     'mastermind/resource'
  autoload :Provider,     'mastermind/provider'
  autoload :DSL,          'mastermind/dsl'
  autoload :Job,          'mastermind/job'

  extend Mixins::Registry
  extend Mixins::Ruote
  extend Mixins::Logger

  resources do
    register :mock,       Mastermind::Resource::Mock
    register :chef_node,  Mastermind::Resource::CM::Chef::Node
    register :campfire,   Mastermind::Resource::Notification::Campfire
    register :email,      Mastermind::Resource::Notification::Email
    register :http,       Mastermind::Resource::Remote::HTTP
    register :ssh,        Mastermind::Resource::Remote::SSH
    register :ssh_multi,  Mastermind::Resource::Remote::SSHMulti
    register :ec2_server, Mastermind::Resource::Server::EC2
  end

  providers do
    register :mock,       Mastermind::Provider::Mock
    register :chef_node,  Mastermind::Provider::CM::Chef::Node
    register :campfire,   Mastermind::Provider::Notification::Campfire
    register :email,      Mastermind::Provider::Notification::Email
    register :http,       Mastermind::Provider::Remote::HTTP
    register :ssh,        Mastermind::Provider::Remote::SSH
    register :ssh_multi,  Mastermind::Provider::Remote::SSHMulti
    register :ec2_server, Mastermind::Provider::Server::EC2
  end

end
