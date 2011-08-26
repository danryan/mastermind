module Mastermind
  class Resource
    include Mixin::Attributes
    include Mixin::Resources

    attr_accessor :provider
    attr_reader :not_if_args
    attr_reader :only_if_args
    
    attribute :action, Symbol
    attribute :name, String, :required => true
    attribute :not_if, Proc
    attribute :only_if, Proc
    attribute :success, Proc
    attribute :failure, Proc
    
    default_action :nothing
        
    def initialize(args={})
      super(args)
    end
    
    def execute(action)
      if self.valid?
        begin
          if only_if
            unless execute_only_if(only_if)
              Mastermind::Log.error "Skipping #{self} due to only_if"
              return
            end
          end
          
          if not_if
            unless execute_not_if(not_if)
              Mastermind::Log.error "Skipping #{self} due to not_if"
              return
            end
          end
          
          provider = self.class.provider.new(self)
          provider.send(action)
          if success
            success.call
          end
          @successful = true
        rescue => e
          Mastermind::Log.error e.inspect
          if failure
            failure.call
          else
            raise e.exception
          end
          @successful = false
        end
        
      else
        Mastermind::Log.error self.errors.full_messages.join(", ")
        raise ValidationError, self.errors.full_messages.join(", ")
      end
    end
    
    def to_s
      "#{resource_name}[#{name}]"
    end
  end
end

class Mastermind::Resource::ValidationError < StandardError; end