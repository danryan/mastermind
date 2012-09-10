class Resource::Mock < Resource
  register :mock
  
  attribute :message, type: String
  
end