class Resource::Mock < Resource
  register :mock
  
  attribute :message, type: String
  
  validates! :message, 
    :presence => true, 
    :on => [ :pass, :modify ]

end