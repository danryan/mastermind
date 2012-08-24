class Target::Mock < Target
  register :mock
  
  attribute :message, type: String
end