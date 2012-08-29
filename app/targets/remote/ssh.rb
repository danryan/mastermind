module Target::Remote
  class SSH < Target
    register :ssh

    attribute :command, type: String
    attribute :host, type: String
    attribute :user, type: String
    attribute :key_data, type: String  
    attribute :output, type: String
    
    validates! :command, :host, :user, :key_data,
      presence: true
  end
end