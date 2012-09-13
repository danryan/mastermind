module Mastermind
  module Mixins
    module Resources

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

      def actions
        self.class.actions
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

        def provider(provider_class)
          @provider = provider_class
          attribute :provider, :type => Object, :default => provider_class
        end

        def actions(*actions)
          @actions ||= [ 'nothing' ]
          @actions << actions.map(&:to_s) unless actions.blank?
          @actions.flatten!
          @actions.each do |act|
            validates! :name,
              :presence => true,
              :on => act
            validates! :action,
              :presence => true,
              :inclusion => { 
                :in => @actions.map(&:to_s)
              },
              :on => act
          end

          return @actions
        end

        def type
          @type
        end

      end
    end
  end
end
