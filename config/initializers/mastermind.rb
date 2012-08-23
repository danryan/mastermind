module Mastermind
  extend self
  
  def logger
    @logger ||= Rails.logger
  end
  
  def logger=(logger)
    @logger = logger
  end
  
  def dashboard
    url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/10'
    storage = Ruote::Redis::Storage.new(::Redis.connect(url: url, thread_safe: true))
    
    @dashboard ||= Ruote::Dashboard.new(Ruote::Worker.new(storage))
  end
  
  def definitions
    @definitions ||= Hash.new.with_indifferent_access
  end
  
  def define(attributes, &block)
    attributes = Hash[attributes].with_indifferent_access
    Mastermind.logger.debug "defined process #{name}", attributes
    definitions[attributes[:name]] = Ruote.process_definition(attributes, &block)
  end
  
end

Mastermind.dashboard.context.logger.noisy = true

# require our participants
Dir[Rails.root + "app/participants/**/*.rb"].each do |file|
  require file
end

# require our definitions
Dir[Rails.root + "app/definitions/**/*.rb"].each do |file|
  require file
end