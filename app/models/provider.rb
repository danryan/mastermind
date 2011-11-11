class Provider
  include DataMapper::Resource
  
  module Mixin
    extend ActiveSupport::Concern
    
    included do
      extend ActiveSupport::DescendantsTracker
    end
    
    module ClassMethods    
      def provider_name(name=nil)
        @provider_name = name.to_s if !name.nil?
        return @provider_name
      end

      def actions(*args)
        @actions = args.map(&:to_s) if !args.empty?
        return @actions
      end
    end
    
    module InstanceMethods
      
    end
    
  end

  include Mixin
  
  provider_name :default
  actions :nothing
  
  property :id, Serial
  property :provider_name, String, :default => self.provider_name
  property :actions, Object, :default => self.actions
  
  has n, :resources

end