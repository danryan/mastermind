require 'ruote'
require 'ruote-redis'

module Mastermind
  module Mixins
    module Ruote

      def self.extended(base)
        base.dashboard.add_service('job_observer', Mastermind::JobObserver)
        Rufus::Json.backend = :json
      end

      def dashboard
        url = ENV['REDIS_URL'] || ENV['REDISTOGO_URL'] || 'redis://localhost:6379/1'
        storage = ::Ruote::Redis::Storage.new(::Redis.connect(url: url, thread_safe: true))
        # worker = Ruote::Worker.new(storage)
        @dashboard ||= ::Ruote::Dashboard.new(storage)
        @dashboard.configure('ruby_eval_allowed', true)
        @dashboard
      end

      def launch(job_or_pdef, fields={}, variables={})
        if job_or_pdef.kind_of?(Job) && fields.empty? && variables.empty?
          # someone launched a job manually
          dashboard.launch(job_or_pdef.pdef, job_or_pdef.fields, { job_id: job_or_pdef.id })
        else
          # assume we're dealing with a ruote-compiled pdef
          dashboard.launch(job_or_pdef, fields, variables)
        end
      end

      def ps(wfid)
        dashboard.process(wfid)
      end

      def define(attributes, &block)
        Ruote.define(attributes, &block)
      end
    end
  end
end


