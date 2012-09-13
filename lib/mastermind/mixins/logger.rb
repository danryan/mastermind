module Mastermind
  module Mixins
    module Logger

      def self.extended(base)
        base.logger.level = ENV['LOG_LEVEL'] && ENV['LOG_LEVEL'].to_sym || :info
        base.dashboard.context.logger.noisy = ENV['MASTERMIND_NOISY'] || false
      end

      def logger
        @logger ||= Mastermind::Logger.new(::STDOUT)
      end

      def logger=(logger)
        @logger = logger
      end
    end
  end
end
