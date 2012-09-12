class Resource::Foo < Resource::Mock
  register :foo

  allowed_actions :pass, :modify, :fail, :bar
  
  attribute :message, :type => String
  attribute :wat, :type => String

  validates! :message,
    :presence => true,
    :on => :bar
end