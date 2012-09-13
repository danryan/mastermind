require 'faraday'
require 'addressable/uri'

module Provider::Remote
  class HTTP < Provider
    register :http

    def url
      @url ||= Addressable::URI.parse(resource.url)
    end

    def connection
      @connection ||= Faraday.new(:url => resource.url)
    end

    action :get do
      response = connection.get do |req|
        req.url url.path
        req.headers = resource.headers
        req.params = url.query_values
      end

      update_resource_attributes({
        :response => {
          :status => response.status, 
          :body => from_content_type(response.body),
          :headers => response.headers
        }
      })
    end

    action :post do
      response = connection.post do |req|
        req.url url.path
        req.headers = resource.headers
        req.params = url.query_values
        req.body = to_content_type(resource.body)
      end

      update_resource_attributes({
        :response => {
          :status => response.status,
          :body => from_content_type(response.body),
          :headers => response.headers
        }
      })
    end

    action :put do
      response = connection.put do |req|
        req.url url.path
        req.headers = resource.headers
        req.params = url.query_values
        req.body = to_content_type(resource.body)
      end

      update_resource_attributes({
        :response => {
          :status => response.status,
          :body => from_content_type(response.body),
          :headers => response.headers
        }
      })
    end

    action :delete do
      response = connection.delete do |req|
        req.url url.path
        req.params = url.query_values
        req.headers = resource.headers
      end

      update_resource_attributes({
        :response => {
          :status => response.status,
          :body => from_content_type(response.body),
          :headers => response.headers
        }
      })
    end

    private

    def to_content_type(body)
      return body unless resource.headers.has_key?('Content-Type')
      case resource.headers['Content-Type']
      when 'application/json'
        MultiJson.dump(body)
      when 'application/xml'
        body.to_xml
      end
    end

    def from_content_type(body)
      return body unless resource.headers.has_key?('Content-Type')
      case resource.headers['Content-Type']
      when 'application/json'
        MultiJson.load(body)
      when 'application/xml'
        Hash.from_xml(body)
      end
    end

  end
end