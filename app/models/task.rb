class Task
  include Mastermind::Mixin::Task

  attribute :name, String, :required => true
  attribute :resources, Array, :default => []
  
  def to_s
    "task[#{name}]"
  end
  
  def execute
    resources.each do |resource|
      resource.execute(resource.action)
    end
  end
  
end
