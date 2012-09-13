# ec2_server "foo bar" do
#   action :create
#   image_id '${image_id}'
#   flavor_id '${flavor_id}'
#   key_name '${key_name}'
#   region '${region}'
#   availability_zone '${availability_zone}'
#   groups '$f:groups'
#   tags '$f:tags'
# end

module Mastermind
  class DSL

    attr_accessor :resources

    def initialize
      @resources = []
    end
    
    def method_missing(meth, *args, &block)
      # Are we are dealing with a resource?
      if Mastermind.resources.has_key?(meth) ? true : false

        # Pull the name from the first argument of the block
        puts args.inspect
        name = args[0]
        puts name

        raise ArgumentError, "a name is required" unless name
        raise ArgumentError, "name must be a String" unless name.is_a?(String)

        resource = Mastermind.resources[meth].new(:name => name)

        # If our resource has a block, instance_eval the block in the resource context
        if block.is_a? Proc
          resource.instance_eval(&block)
        end

        @resources << resource

      # If we're not dealing with a resource, escalate it with super.
      else
        super(meth, *args, &block)
      end
    end
    
  end # class DSL

  def self.dsl
    Mastermind::DSL.new
  end
end # module Mastermind

