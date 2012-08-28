module Target::Remote
  class HTTP < Target
    register :http

    attribute :payload, type: String
    attribute :headers, type: Object, default: {}
    attribute :url, type: String
    attribute :verb, type: String  
    attribute :response, type: String
  end
end