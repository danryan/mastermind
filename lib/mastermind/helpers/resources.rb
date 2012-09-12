module Mastermind::Helpers::Resources

  def self.inherited(subclass)
    subclass.attributes = attributes.dup
    super
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def run #(action)
    provider = self.provider.new(self)
    provider.action = self.action
    provider.run
    # TODO: rescue exceptions
  end

  def allowed_actions
    self.class.allowed_actions
  end

  # Override ActiveAttr::Attributes#attribute to provide a Chef-style DSL syntax
  def attribute(name, value=nil)
    if value
      write_attribute(name, value)
    else
      super(name)
    end
  end

  module ClassMethods
    def register(type)
       @type = type.to_s
       Mastermind.resources[type.to_sym] = self
    end

    def allowed_actions(*actions)
      @allowed_actions ||= [ 'nothing' ]
      @allowed_actions << actions.map(&:to_s) unless actions.blank?
      @allowed_actions.flatten!
      @allowed_actions.each do |act|
        validates! :name,
          :presence => true,
          :on => act
        validates! :action,
          :presence => true,
          :inclusion => { 
            :in => @allowed_actions.map(&:to_s)
          },
          :on => act
      end

      return @allowed_actions
    end

    def type
      @type
    end

  end
end
