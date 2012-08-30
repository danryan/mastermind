module Target::Remote
  class SSHMulti < Target
    register :ssh_multi

    attribute :command, type: String
    attribute :hosts, type: Object
    attribute :user, type: String
    attribute :key_data, type: String  
    attribute :output, type: String
    
    validates! :command, :hosts, :user, :key_data,
      presence: true
  end
end