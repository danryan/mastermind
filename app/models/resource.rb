class Resource
  include DataMapper::Resource

  module Mixin
    extend ActiveSupport::Concern
    
    included do
      extend ActiveSupport::DescendantsTracker
    end
    
    module ClassMethods    
      def resource_name(name=nil)
        @resource_name = name.to_s if !name.nil?
        return @resource_name
      end

      def provider_name(name=nil)
        @resource_name = name.to_s if !name.nil?
        return @resource_name
      end

      def default_action(action=nil)
        @default_action = action.to_s if !action.nil?
        return @default_action
      end
    end
    
    module InstanceMethods
      
    end
    
  end

  include Mixin
  
  resource_name :default
  provider_name :default
  default_action :nothing 
  
  property :id, Serial
  property :resource_name, String, :default => self.resource_name
  property :provider_name, String, :default => self.provider_name
  property :action, String, :default => self.default_action
  property :name, String, :required => true, :unique => true
  
  belongs_to :provider
  belongs_to :task
  
  before :save, :find_provider
  
  def find_provider
    provider = Provider.first(:provider_name => self.class.provider_name)
    self.provider = provider
  end
  
end
