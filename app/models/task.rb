class Task
  module Mixin
    extend ActiveSupport::Concern
    include Ascribe::Attributes

    included do
      extend ActiveSupport::DescendantsTracker
    end

    module ClassMethods
      def from_hash(hash)
        resources = hash.delete('resources')
        result = Task.new(hash)
        result.resources = resources.map { |task| Resource.from_hash(task) }
        return result
      end

      def from_json(json)
        hash = Yajl.load(json)
        resources = hash.delete('resources')
        result = Task.new(hash)
        result.resources = resources.map{ |task| Resource.from_hash(task) }
        return result
      end

       def find(id)
         begin
           record = Task.from_json($redis.get("mastermind::plot:#{id}"))
           return record
         rescue Yajl::ParseError
           Log.debug("Could not find a record with id #{id}")
           nil
         end
       end

    end

    module InstanceMethods

      def initialize(attrs={}, &block)
        if block_given?
          if block.arity == 1
            yield self
          else
            instance_eval &block
          end
        end
        Mastermind::Registry.resources.each_pair do |key, value|
          class_eval do
            define_method key do |name, &block|
              dsl_method(name, value, &block)
            end
          end
        end
        super(attrs)
      end

      def save
        if valid?
          @id ||= $redis.incr("#{self.class.name.downcase}:next_id")
          $redis.set("#{self.class.name.downcase}:#{id}", self.to_json)
          return self
        else
          raise Mastermind::ValidationError, self.errors.full_messages.join(", ")
        end
      end


      def dsl_method(name, klass, &block)
        resource = klass.new rescue Resource.new
        resource.name = name
        resource.action = (resource.action ? resource.action : klass.default_action)
        if block_given?
          resource.instance_eval(&block)
        end
        resources["#{resource.resource_name}[#{resource.name}]"] = resource.options
      end

      def to_hash
        result = attributes.merge(options)
        result['resources'].map!(&:to_hash)
        return result
      end

      def to_json(*a)
        result = Yajl.dump(to_hash, *a)
        return result
      end
    end
  end
  
  include Mixin

  attribute :name, String, :required => true
  attribute :resources, Array, :default => []
  
  def to_s
    "task[#{name}]"
  end
  
  def execute
    resources.each do |resource|
      resource.execute(resource.action)
    end
  end
  
end
