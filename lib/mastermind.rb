require 'ruote'
require 'ruote-redis'

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

$VERBOSE = nil

json_lib = defined?(RUBY_PLATFORM) && RUBY_PLATFORM == "java" ? 'json' : 'yajl'

begin
  require json_lib
  Rufus::Json.backend = json_lib.to_sym
rescue LoadError => e
  raise LoadError, "Please install #{json_lib}: `gem install #{json_lib}` (#{e.message})", e.backtrace
end

JSON.create_id = nil

module Mastermind
  autoload :AWS,         'mastermind/aws'
  autoload :Resource,    'mastermind/resource'
  autoload :Provider,    'mastermind/provider'
  autoload :DSL,         'mastermind/dsl'
  autoload :Job,         'mastermind/job'
  autoload :JobObserver, 'mastermind/job_observer'

  def self.logger
    cabin = Cabin::Channel.new 
    cabin.subscribe(STDOUT)
    @logger ||= cabin
    @logger
  end
  
  def self.logger=(logger)
    @logger = logger
  end
  
  def self.dashboard
    url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/1'
    storage = Ruote::Redis::Storage.new(::Redis.connect(url: url, thread_safe: true))
    # worker = Ruote::Worker.new(storage)
    @dashboard ||= Ruote::Dashboard.new(storage)
    @dashboard.configure('ruby_eval_allowed', true)
    @dashboard
  end
  
  def self.resources
    @resources ||= Hash.new.with_indifferent_access
  end
  
  def self.providers
    @providers ||= Hash.new.with_indifferent_access
  end
  
  def self.launch(job_or_pdef, fields={}, variables={})
    if job_or_pdef.kind_of?(Job) && fields.empty? && variables.empty?
      # someone launched a job manually
      Mastermind.dashboard.launch(job_or_pdef.pdef, job_or_pdef.fields, { job_id: job_or_pdef.id })
    else
      # assume we're dealing with a ruote-compiled pdef
      Mastermind.dashboard.launch(job_or_pdef, fields, variables)
    end
  end
  
  def self.ps(wfid)
    Mastermind.dashboard.process(wfid)
  end
  
  def self.define(attributes, &block)
    Ruote.define(attributes, &block)
  end
end

Mastermind.dashboard.add_service('job_observer', Mastermind::JobObserver)

Mastermind.dashboard.context.logger.noisy = ENV['MASTERMIND_NOISY'] || false
Mastermind.logger.level = ENV['LOG_LEVEL'] && ENV['LOG_LEVEL'].to_sym || :info

# # require our resources
# Dir[Rails.root + 'app/models/resource/**/*.rb'].each do |file|
#   require file
# end

# # require our providers
# Dir[Rails.root + 'app/models/provider/**/*.rb'].each do |file|
#   require file
# end

