require 'ruote/util/process_observer'

class Mastermind::JobObserver < Ruote::ProcessObserver
  
  attr_accessor :job
  
  def initialize(context, options={})
    super
  end
  
  def on_launch(wfid, options)
    @job = Job.find(options[:variables]['job_id'])
    @job.run
  end
  
  def on_terminated(wfid, options)
    @job.results = options[:workitem].fields
    @job.last_success_at = DateTime.now
    @job.complete
  end
  
  def on_error_intercepted(wfid, options)
    @job.last_failure_at = DateTime.now
    @job.error
  end
  
  def on_cancel(wfid, options)
    @job.cancel
  end

end