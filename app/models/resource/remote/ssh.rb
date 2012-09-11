module Resource::Remote
  class SSH < Resource
    register :ssh

    attribute :command, :type => String
    attribute :host, :type => String
    attribute :user, :type => String
    attribute :key_data, :type => String  
    attribute :output, :type => String
    
    validates! :command, :host, :user, :key_data,
      :presence => true,
      :on => :run
  end
end