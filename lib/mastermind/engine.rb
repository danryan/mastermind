require 'ruote'
require 'ruote/storage/fs_storage'

module Mastermind
  # Rails autoload magic is stupid 
  module Engine
    class << self
      def storage
        @storage ||= ::Ruote::FsStorage.new('ruote_work')
      end

      def worker
        @worker ||= ::Ruote::Worker.new(storage)
      end

      def engine
        @engine ||= ::Ruote::Engine.new(worker)
      end
    end
  end
  
  Mastermind::Engine.engine.register_participant :mock_run do |workitem|
    ::Provider::Mock.new(:new_resource => workitem.fields).run
  end


  Mastermind::Engine.engine.register_participant :mock_fail do |workitem|
    ::Provider::Mock.new(:new_resource => workitem.fields).fail
  end
end