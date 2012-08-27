require 'ruote/util/process_observer'

class Mastermind::TaskObserver < Ruote::ProcessObserver
  
  attr_accessor :task
  
  def initialize(context, options={})
    super
  end
  
  def on_launch(wfid, options)
    @task = get_task
    
    @task.run
  end
  
  def on_terminated(wfid, options)
    @task.result = options[:workitem].fields
    @task.complete
  end
  
  def on_error_intercepted(wfid, options)
    @task.error
  end
  
  def on_cancel(wfid, options)
    @task.cancel
  end
  
  private
  def get_task
    Task.find(options[:variables]['task_id'])
  end
end