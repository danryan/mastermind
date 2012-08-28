class Job < ActiveRecord::Base
  attr_accessible :name, :tasks, :fields
  
  # has_many :tasks, order: "position"
  serialize :tasks, JSON
  serialize :fields, JSON
  
  validates :name, presence: true, uniqueness: true
  
  def to_pdef
    str = ""
    str << "Ruote.process_definition :name => '#{name}' do\n"
    tasks.each do |task|
      str << "\t#{task}\n"
    end
    str << "end"
    
    Ruote::Reader.read(str)
  end
end
