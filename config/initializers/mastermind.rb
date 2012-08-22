module Mastermind
  extend self
  
  def logger
    @logger ||= Rails.logger
  end
  
  def logger=(logger)
    @logger = logger
  end
  
  def dashboard
    url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/0'
    
    @dashboard ||= Ruote::Dashboard.new(
      Ruote::Worker.new(
        Ruote::Redis::Storage.new(
          ::Redis.connect(:url => url, :thread_safe => true))))
  end
  
end

Dir[File.join(Rails.root, "app", "participants", "*.rb")].each do |file_name|
  require(File.join(File.dirname(file_name), File.basename(file_name, ".rb")))
end