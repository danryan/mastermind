module Mastermind
  module Mixins
    module Registry

      def resources(&block)
        @resources ||= Mastermind::Registry.new

        unless block.nil?
          @resources.instance_eval(&block)
        end

        return @resources
      end

      def providers(&block)
        @providers ||= Mastermind::Registry.new

        unless block.nil?
          @providers.instance_eval(&block)
        end

        return @providers
      end
    end
  end
end
