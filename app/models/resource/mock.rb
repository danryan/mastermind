class Resource::Mock < Resource
  register :mock

  allowed_actions :pass, :modify, :fail
  
  attribute :message, :type => String
  
  [ :pass, :modify ].each do |act|
    validates! :message, 
      :presence => true, 
      :on => act
  end

end