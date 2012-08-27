class Task < ActiveRecord::Base
  attr_accessible :definition, :fields, :name, :result
  
  serialize :fields, JSON
  serialize :result, JSON
  
  before_save :convert_fields_to_hash
  
  def launch
    pdef = Definition.find(definition).pdef
    self.last_wfid = Mastermind.dashboard.launch(pdef, fields, { task_id: id })
    save
  end
  
  state_machine :initial => :pending do
    state :pending
    state :running
    state :failed
    state :completed
    state :canceled
    
    event :run do
      transition :pending => :running
    end
    
    event :error do
      transition :running => :failed
    end
    
    event :complete do
      transition :running => :completed
    end
    
    event :cancel do
      transition :running => :canceled
    end
  end
  
  private
  
  def convert_fields_to_hash
    if fields.is_a?(String)
      self.fields = Rufus::Json.decode(fields)
    end
  end
end
