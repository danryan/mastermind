module Mastermind
  class Resource
    include Mixin::Attributes
    include Mixin::Resources

    attr_accessor :provider
    
    attribute :action, Symbol
    attribute :name, String, :required => true
    
    default_action :nothing
    
    def execute(action)
      # begin
        if self.valid?
          provider = self.class.provider.new(self)
          provider.send(action)
        else
          raise ValidationError, self.errors.full_messages.join(", ")
        end
      # rescue => ValidationError
        # puts "Something went wrong! " + e.message
      # end
    end
  end
end

module Mastermind
  class Resource
    class ValidationError < StandardError
    end
  end
end