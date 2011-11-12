class Resource
  
  module Mixin
    extend ActiveSupport::Concern
    include Ascribe::Attributes

    included do
      extend ActiveSupport::DescendantsTracker
    end

    module ClassMethods
      def resource_name(resource_name=nil)
        @resource_name = resource_name.to_s if !resource_name.nil?
        Mastermind::Registry.resources[@resource_name] = self
        attribute :resource_name, [String, Symbol], :default => @resource_name
        return @resource_name
      end

      def provider_name(provider_name=nil)
        @provider_name = provider_name.to_s if !provider_name.nil?
        attribute :provider_name, [String, Symbol], :default => @provider_name
        return @provider_name
      end

      def provider 
        attribute :provider, Object
        return @provider
      end

      def default_action(name=nil)
        @default_action = name.to_s if !name.nil?
        attribute :default_action, [String, Symbol], :default => @default_action
        return @default_action
      end

      def find_by_name(name)
        Mastermind::Registry.resources[name]
      end

      def dsl_method(name, resource, &block)
        new_resource = resource.new
        new_resource.name name
        new_resource.action ( new_resource.action || new_resource.default_action)
        new_resource.instance_eval(&block)
        tasks << new_resource
      end

      def from_hash(hash)
        resource = find_by_name(hash["resource_name"])
        result = resource.new(hash)
        return result
      end

      def from_json(json)
        hash = Yajl.load(json)
        resource = find_by_name(hash["resource_name"])
        result = resource.new(hash)
        return result
      end
    end

    module InstanceMethods

      def initialize(attrs={})
        @provider = Mastermind::Registry.providers[self.class.provider_name]
        super(attrs)
      end

      def execute_only_if(only_if)
        res = instance_eval { only_if.call }
        unless res
          return false
        end
        true
      end

      def execute_not_if(not_if)
        res = instance_eval { not_if.call }
        if res
          return false
        end
        true
      end

      def to_hash
        result = attributes.merge(options)
        return result
      end

      def to_json(*a)
        result = Yajl.dump(to_hash, *a)
        return result
      end

      def to_s
        "resource[#{resource_name}::#{name}]"
      end

    end  
  end
  
  include Mixin

  attr_accessor :provider

  resource_name :default
  default_action :nothing

  attribute :action, [Symbol, String]
  attribute :name, String, :required => true
  attribute :not_if, Proc
  attribute :only_if, Proc
  attribute :on_success, [Array, String], :default => []
  attribute :on_failure, [Array, String], :default => []

  def execute(action=nil)
    if self.valid?
      begin
        if only_if
          unless execute_only_if(only_if)
            Mastermind::Log.debug "Skipping #{self} due to only_if"
            return
          end
        end

        if not_if
          unless execute_not_if(not_if)
            Mastermind::Log.debug "Skipping #{self} due to not_if"
            return
          end
        end

        provider = self.provider.new(:resource => self)
        provider.send(action || self.class.default_action)
        if !on_success.empty? && !on_success.nil?
          Mastermind::Log.debug "Action succeeded. Executing success callbacks"
          if on_success.is_a?(String)
            Mastermind::Log.debug "Executing success callback: #{on_success}"
            plot.tasks[on_success].execute

          else
            to_execute = []
            on_success.each do |success_callback|
              to_execute << plot.tasks[success_callback]
            end
            to_execute.each do |success_callback|
              Mastermind::Log.debug "Executing success callback: #{success_callback}"
              success_callback.execute
            end
          end
        end
      rescue => e
        Mastermind::Log.error "#{e.message}\n#{e.backtrace.join("\n")}"

        if !on_failure.empty? && !on_failure.nil?
          Mastermind::Log.debug "Action failed. Executing failure callbacks"
          if on_failure.is_a?(String)
            Mastermind::Log.debug "Executing failure callback: #{on_failure}"
            plot.tasks[on_failure].execute
          else
            to_execute = []
            on_failure.each do |failure_callback|
              to_execute << plot.tasks[failure_callback]
            end
            to_execute.each do |failure_callback|
              Mastermind::Log.debug "Executing failure callback: #{failure_callback}"
              failure_callback.execute
            end
          end
        else
          Mastermind::Log.error "#{e.message}\n#{e.backtrace.join("\n")}"
          raise e.exception
        end
        @successful = false
      end

    else
      Mastermind::Log.error self.errors.full_messages.join(", ")
      raise Mastermind::ValidationError, self.errors.full_messages.join(", ")
    end
  end

  
  
end

