module Mastermind
  class Resource
    include Mixin::Attributes
    include Mixin::Resources

    attr_accessor :provider
    attr_reader :not_if_args
    attr_reader :only_if_args
    
    attribute :action, [Symbol, String]
    attribute :name, String, :required => true
    attribute :not_if, Proc
    attribute :only_if, Proc
    attribute :on_success, [Array, String], :default => []
    attribute :on_failure, [Array, String], :default => []
    attribute :plot
    
    # attribute :ignore_failure, [ TrueClass, FalseClass ], :default => false
    
    resource_name :default
    default_action :nothing
        
    def initialize(args={})
      super(args)
    end
    
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
          
          provider = self.class.provider.new(self)
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
    
    def to_s
      "#{resource_name}[#{name}]"
    end
    
    def inspect
      attrs = options.map do |option|
        "@#{option[0]}=#{option[1]}"
      end
      "#<Resource #{attrs.join(" ")}>"
    end

    def to_hash
      result = options.merge("resource_name" => resource_name.to_s)
      return result
    end
    
    def to_json(*a)
      to_hash.to_json(*a)
    end
  end
end