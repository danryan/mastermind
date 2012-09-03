module Mastermind
  extend self
  
  def logger
    @logger ||= Rails.logger
  end
  
  def logger=(logger)
    @logger = logger
  end
  
  def dashboard
    url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/1'
    storage = Ruote::Redis::Storage.new(::Redis.connect(url: url, thread_safe: true))
    worker = Ruote::Worker.new(storage)
    @dashboard ||= Ruote::Dashboard.new(worker)
    @dashboard.configure('ruby_eval_allowed', true)
    @dashboard
  end
  
  def targets
    @targets ||= Hash.new.with_indifferent_access
  end
  
  def participants
    @participants ||= Hash.new.with_indifferent_access
  end
  
  def launch(job_or_pdef, fields={}, variables={})
    if job_or_pdef.kind_of?(Job) && fields.empty? && variables.empty?
      # someone launched a job manually
      Mastermind.dashboard.launch(job.pdef, job.fields, { job_id: job.id })
    else
      # assume we're dealing with a ruote-compiled pdef
      Mastermind.dashboard.launch(job_or_pdef, fields, variables)
    end
  end
  
  def ps(wfid)
    Mastermind.dashboard.process(wfid)
  end
  
  def define(attributes, &block)
    Ruote.define(attributes, &block)
  end
end

Mastermind.dashboard.add_service('job_observer', Mastermind::JobObserver)

Mastermind.dashboard.context.logger.noisy = ENV['MASTERMIND_NOISY'] || false
Mastermind.logger.level = ENV['MASTERMIND_LOG_LEVEL'].try(:to_sym) || :info

# require our targets
Dir[Rails.root + "app/targets/**/*.rb"].each do |file|
  require file
end

# require our participants
Dir[Rails.root + "app/participants/**/*.rb"].each do |file|
  require file
end

JSON.create_id = nil