require 'redis'
require 'ruote'
require 'ruote-redis'

namespace :ruote do
  task :setup
  
  desc "Run a worker process for ruote"
  task :work => [ :environment, :preload, :setup] do
    url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/1'
    storage = Ruote::Redis::Storage.new(::Redis.connect(url: url, thread_safe: true), {})      
    # ruote = Ruote::Dashboard.new(Ruote::Worker.new(storage))
    # ruote.join
    RuoteKit.run_worker(storage)
    
    Signal.trap('INT') do
      RuoteKit.engine.shutdown
      RuoteKit.engine.storage.purge!
    end
    
  end
  # 
  # desc "Start multiple ruote workers."
  # task :workers 
  
  task :preload => :setup do
    if defined?(Rails) && Rails.respond_to?(:application)
      Rails.application.eager_load!
    end
  end
  
end
