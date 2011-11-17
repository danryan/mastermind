class Provider
  include Mastermind::Mixin::Provider
  
  attr_accessor :new_resource
  
  provider_name nil
  actions :nothing
  
  def initialize(attrs={})
    @new_resource = attrs.delete(:resource)
    super(attrs)
  end
  
  def self.find_by_name(name)
    Mastermind::Registry.providers[name]
  end
  
  def execute
    self.send(self.action)
  end
  
  def to_s
    "provider[#{provider_name}]"
  end
  

end