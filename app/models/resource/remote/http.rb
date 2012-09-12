module Resource::Remote
  class HTTP < Resource
    register :http

    allowed_actions :get, :post, :put, :delete

    attribute :body, :type => Object, :default => {}
    attribute :headers, :type => Object, :default => { 'Content-Type' => 'application/json',
                                                       'Accept' => 'application/json' }
    attribute :url, :type => String
    attribute :verb, :type => String  
    attribute :response, :type => Object, :default => {}
    attribute :status, :type => Integer

  end
end