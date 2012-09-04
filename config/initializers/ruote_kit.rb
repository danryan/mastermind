require 'yajl'
Rufus::Json.backend = :yajl
JSON.create_id = nil
# 
# url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/1'
# storage = Ruote::Redis::Storage.new(::Redis.connect(url: url, thread_safe: true))
# 
# @dashboard ||= Ruote::Dashboard.new(storage)
# @dashboard.configure('ruby_eval_allowed', true)

RuoteKit.engine = Mastermind.dashboard
