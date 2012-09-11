module Resource::Remote
  class HTTP < Resource
    register :http

    attribute :payload, :type => String
    attribute :headers, :type => Object, :default => {}
    attribute :url, :type => String
    attribute :verb, :type => String  
    attribute :response, :type => String
    attribute :status, :type => String
  end
end