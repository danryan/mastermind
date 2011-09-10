require 'active_model'
require 'active_support/concern'

module Mastermind
  module Mixin
    module Persistence
      extend ActiveSupport::Concern
      
      included do
        extend ActiveSupport::DescendantsTracker
      end
      
      module ClassMethods
        def find(id)
          begin
            attrs = Yajl.load($redis.get("#{self.name.downcase}:#{id}"))
            record = new(attrs)
            return record
          rescue Yajl::ParseError
            Mastermind::Log.debug("Could not find a record with id #{id}")
            nil
          end
        end

      end
      
      module InstanceMethods
        def save
          if valid?
            @id ||= $redis.incr("#{self.class.name.downcase}:next_id")
            $redis.set("#{self.class.name.downcase}:#{id}", self.to_json)
            return self
          else
            raise Mastermind::ValidationError, self.errors.full_messages.join(", ")
          end
        end
        
      end
      
    end
  end
end