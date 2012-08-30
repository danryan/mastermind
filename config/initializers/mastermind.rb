module Ruote
  class << self
    
    def definitions
      @definitions ||= {}
    end
    
    def definitions=(defs)
      @definitions = defs
    end
    
    def define(*attributes, &block)

      pdef = RubyDsl.create_branch('define', attributes, &block) 

      if (name = pdef[1]['name'])
        definitions[name] = pdef
      end

      return pdef
    end
    
    def definition(name)
      definitions[name]
    end
    
  end
end

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
  
  # def definitions
  #   # @definitions ||= Hash.new.with_indifferent_access
  #   @definitions ||= []
  # end
  
  def define(attributes, &block)
    # attributes = Hash[attributes].with_indifferent_access
    # Mastermind.logger.debug "defined process #{attributes[:name]}", attributes
    Ruote.define(attributes, &block)
  end
  
  def definitions
    @definitions ||= Ruote.definitions.keys.map do |name|
      Definition.new(Ruote.definition(name))
    end
  end
  
  def definitions=(defs)
    @definitions = defs
  end
  
  def definition(name)
    Definition.new(Ruote.definition(name))
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
  
  # def reload(name=nil)
  #   case name.to_sym
  #   when :definitions
  #     Ruote.definitions = {}
  #     definitions = []
  #     Dir[Rails.root + "app/definitions/**/*.rb"].each { |file| load file }
  #   end
  # end
end

Mastermind.dashboard.add_service('job_observer', Mastermind::JobObserver)

Mastermind.dashboard.context.logger.noisy = ENV['MASTERMIND_NOISY'] || false

# require our targets
Dir[Rails.root + "app/targets/**/*.rb"].each do |file|
  require file
end

# require our participants
Dir[Rails.root + "app/participants/**/*.rb"].each do |file|
  require file
end

# require our definitions
Dir[Rails.root + "app/definitions/**/*.rb"].each do |file|
  require file
end

