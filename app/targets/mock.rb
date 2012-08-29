class Target::Mock < Target
  register :mock
  
  attribute :message, type: String
  
  validates! :message,
    format: { with: /\A[a-zA-Z]+\z/ },
    allow_nil: true
end