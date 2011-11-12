class Provider
  module Mixin

    extend ActiveSupport::Concern
    include Ascribe::Attributes

    included do
      extend ActiveSupport::DescendantsTracker
    end

    module ClassMethods
      def provider_name(provider_name=nil)
        @provider_name = provider_name.to_s if !provider_name.nil?
        Mastermind::Registry.providers[@provider_name] = self
        attribute :provider_name, [String, Symbol], :default => @provider_name, :required => true

        return @provider_name
      end

      def actions(*args)
        @actions = args.map(&:to_s) if !args.empty?
        attribute :actions, Array, :default => @actions
        return @actions
      end

      def action(name, &block)
        define_method name do |&block|
          instance_eval(block)
        end
      end
      
      def find_by_name(name)
        Mastermind::Registry.providers[name.to_s]
      end

      def from_hash(hash)
        provider = find_by_name(hash["provider_name"])
        result = provider.new(hash)
        return result
      end

      def from_json(json)
        hash = Yajl.load(json)
        provider = find_by_name(hash["provider_name"])
        result = provider.new(hash)
        return result
      end

    end

    module InstanceMethods

      def requires(*args)
        missing = []
        args.each do |arg|
          unless new_resource.send("#{arg}") || new_resource.options.has_key?(arg)
            missing << arg
          end
        end
        if missing.length == 1
          raise(ArgumentError, "#{missing.first} is required for this operation")
        elsif missing.any?
          raise(ArgumentError, "#{missing[0...-1].join(", ")} and #{missing[-1]} are required for this operation")
        end

      end

      def to_hash
        result = attributes.merge(options)
        return result
      end

      def to_json(*a)
        result = Yajl.dump(to_hash, *a)
        return result
      end
    end

  end
  
  include Mixin
  
  attr_accessor :new_resource
  
  provider_name nil
  actions :nothing
  
  def initialize(attrs={})
    @new_resource = attrs.delete(:resource)
    super(attrs)
  end
  
  def self.find_by_name(name)
    Mastermind::Registry.providers[name]
  end
  
  def execute
    self.send(self.action)
  end
  
  def to_s
    "provider[#{provider_name}]"
  end
  

end