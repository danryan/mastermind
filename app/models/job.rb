class Job < ActiveRecord::Base
  attr_accessible :name, :tasks, :fields, :definition
  
  # has_many :tasks, order: "position"
  # serialize :tasks, JSON
  serialize :fields, JSON
  
  validates :name, 
    presence: true, 
    uniqueness: true
  
  def pdef
    Mastermind.definition(definition).pdef
  end
  
end
