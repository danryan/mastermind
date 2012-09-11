require 'net/ssh'

module Provider::Remote
  class HTTP < Provider

    def connection
      @connection ||= Faraday.new(:url => resource.url)
    end

    register :http
    
    # attribute :payload, :type => Object, :default =>  {}
    # attribute :headers, :type => Object, :default =>  {}
    # attribute :url, :type => String
    # attribute :verb, :type => String
    # attribute :response, :type => String

    action :get do      
      resource.output = run_ssh(resource.command)
      
      {}
    end

    action :post do
    end

    action :put do
    end

    action :delete do
    end

  end
end