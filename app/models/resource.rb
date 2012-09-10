class Resource
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
    
  self.include_root_in_json = false

  def self.register(type)
    @type = type
    Mastermind.resources[type.to_sym] = self
  end
  
end