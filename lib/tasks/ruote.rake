require 'redis'
require 'ruote'
require 'ruote-redis'

namespace :ruote do
  desc "Run a worker thread for ruote"
  task :run_worker => :environment do    
    url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/0'
    storage = Ruote::Redis::Storage.new(::Redis.connect(url: url, thread_safe: true), {})
    # worker = Ruote::Worker.new(storage)
    RuoteKit.run_worker(storage)
    
    Signal.trap('INT') do
      RuoteKit.engine.shutdown
      RuoteKit.engine.storage.purge
    end
    
  end
end
