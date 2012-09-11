class Resource
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes

  attribute :action, :type => String
  attribute :name, :type => String
  attribute :type, :type => String, :default =>  lambda { self.class.type }
  attribute :provider, :type => Object, :default =>  lambda { Mastermind.providers[self.class.type] }

  validates! :action, :name,
    :presence => true

  def run #(action)
    provider = self.provider.new(self)
    provider.action = self.action
    provider.run
    # TODO: rescue exceptions
  end

  self.include_root_in_json = false

  # Override ActiveAttr::Attributes#attribute to provide a Chef-style DSL syntax
  def attribute(name, value=nil)
    if value
      write_attribute(name, value)
    else
      super(name)
    end
  end

  class << self
    def register(type)
      @type = type.to_s
      Mastermind.resources[type.to_sym] = self
    end

    def type
      @type
    end

    def validates!(*args)
      options = args.extract_options!
      on = options.delete(:on)
      if on.is_a?(Array)
        on.each do |action|
          super(*args, options.merge(:on => action))
        end
      else
        super(*args, options.merge(:on => on))
      end
    end
  end

end