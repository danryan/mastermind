class Resource
  include Mastermind::Helpers::Resources
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes

  attribute :action, :type => String
  attribute :name, :type => String
  attribute :type, :type => String, :default =>  lambda { self.class.type }
  attribute :provider, :type => Object, :default =>  lambda { Mastermind.providers[self.class.type] }

  # allowed_actions :nothing

  self.include_root_in_json = false

end
