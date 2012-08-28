class Task < ActiveRecord::Base
  attr_accessible :definition, :fields, :name, :result

  belongs_to :job

  acts_as_list scope: :job
  
  serialize :fields, JSON
  serialize :result, JSON

  validates :name, format: { without: /^\d/ }, 
                   presence: true, 
                   uniqueness: { scope: :job_id }
  
  before_save :convert_fields_to_hash, if: Proc.new { |task| task.fields.is_a?(String) }

  # def self.find(input)
  #   input.to_i == 0 ? find_by_name(input) : super
  # end

  def to_param
    name
  end
  
  def launch(override_fields={})
    merged_fields = fields.deep_merge(override_fields)
    pdef = Mastermind.definition(definition).pdef
    self.last_wfid = Mastermind.dashboard.launch(pdef, merged_fields, { task_id: id })
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
    self.fields = Rufus::Json.decode(fields)
  end
end
