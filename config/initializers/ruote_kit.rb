# make changes when needed
#
# you may use another persistent storage for example or include a worker so that
# you don't have to run it in a separate instance
#
# See http://ruote.rubyforge.org/configuration.html for configuration options of
# ruote.

# we will use yajl for json encoding/decoding
# you may whish to use another one (json, json_pure) if yajl is not available
#
require 'yajl'
Rufus::Json.backend = :yajl

url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/0'

RUOTE_STORAGE = Ruote::Redis::Storage.new(::Redis.connect(:url => url, :thread_safe => true), {})

RuoteKit.engine = Mastermind.dashboard

# By default, there is a running worker when you start the Rails server. That is
# convenient in development, but may be (or not) a problem in deployment.
#
# Please keep in mind that there should always be a running worker or schedules
# may get triggered to late. Some deployments (like Passenger) won't guarantee
# the Rails server process is running all the time, so that there's no always-on
# worker. Also beware that the Ruote::HashStorage only supports one worker.
#
# If you don't want to start a worker thread within your Rails server process,
# replace the line before this comment with the following:
#
# RuoteKit.engine = Ruote::Engine.new(RUOTE_STORAGE)
#
# To run a worker in its own process, there's a rake task available:
#
#     rake ruote:run_worker
#
# Stop the task by pressing Ctrl+C

unless $RAKE_TASK
  # don't register participants when the run is triggered by a rake task

  # RuoteKit.dashboard.register do
  # 
  #   # register your own participants using the participant method
  #   #
  #   # Example: participant 'alice', Ruote::StorageParticipant see
  #   # http://ruote.rubyforge.org/participants.html for more info
  # 
  #   # register the catchall storage participant named '.+'
  #   catchall
  # end
end

# when true, the engine will be very noisy (stdout)
#
RuoteKit.dashboard.noisy = true

# require Rails.root.join('app/models/workitem.rb')
