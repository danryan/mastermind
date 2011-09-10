require 'bundler'
Bundler.setup(:default)

require 'yajl'
require 'sinatra'
require 'rake'
require 'redis'

require 'mastermind/version'
require 'mastermind/log'
require 'mastermind/registry'

require 'mastermind/mixin/attributes'
require 'mastermind/mixin/persistence'
require 'mastermind/mixin/resources'
require 'mastermind/mixin/providers'
require 'mastermind/plot'

require 'mastermind/resource'
require 'mastermind/resource/test'
require 'mastermind/resource/cm'
require 'mastermind/resource/cm/chef'
require 'mastermind/resource/dns'
require 'mastermind/resource/dns/record'
require 'mastermind/resource/dns/record/route53'
require 'mastermind/resource/dns/zone'
require 'mastermind/resource/dns/zone/route53'
require 'mastermind/resource/server'
require 'mastermind/resource/server/ec2'

require 'mastermind/provider'
require 'mastermind/provider/test'
require 'mastermind/provider/cm'
require 'mastermind/provider/cm/chef'

require 'mastermind/provider/dns'
require 'mastermind/provider/dns/zone/route53'
require 'mastermind/provider/server'
require 'mastermind/provider/server/ec2'

module Mastermind
  class << self
    def config_path=(path)
      @config_path = path
    end
    
    def config_path
      @config_path ||= File.expand_path(File.dirname(__FILE__) + "/../config/mastermind.yml")
    end
    
    def config
      @config ||= {}
      @config.merge!(YAML.load_file(config_path))
    end
  end
  
  $redis = ::Redis.new(
    :host => Mastermind.config['redis']['host'],
    :port => Mastermind.config['redis']['port'],
    :db => Mastermind.config['redis']['db']
  )
end