class Job < ActiveRecord::Base
  attr_accessible :name, :fields, :definition, :results
  
  serialize :fields, JSON
  serialize :last_results, JSON
  serialize :current_fields, JSON
  
  validates :name, 
    presence: true, 
    uniqueness: true
  
  belongs_to :definition
  
  def pdef
    definition.to_pdef
  end
  
  before_save :convert_fields_to_hash, 
    if: Proc.new { |job| job.fields.is_a?(String) }

  def launch(override_fields={}, *args)
    merged_fields = fields.deep_merge(override_fields)
    self.last_wfid = Mastermind.launch(pdef, merged_fields, { job_id: id })
    save
    super
  end
  
  def ps
    Mastermind.ps(last_wfid)
  end
  
  state_machine :initial => :pending do
    state :pending
    state :launched
    state :running
    state :failed
    state :completed
    state :canceled

    event :launch do
      transition [:pending, :completed, :failed, :canceled] => :launched
    end
    
    event :run do
      transition :launched => :running
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
    self.fields = Rufus::Json.decode(fields)
  end
   
end
