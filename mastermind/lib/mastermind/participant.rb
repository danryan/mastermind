module Mastermind
  class Participant
    include Ruote::LocalParticipant

    attr_accessor :resource, :provider

    def on_workitem
      Mastermind.logger.debug :provider => type, :action => action, :params => params, :fields => fields

      @resource = Mastermind.resources[self.class.type].new(params)

      Mastermind.logger.debug "attributes", attributes
      Mastermind.logger.debug "fields", fields
      Mastermind.logger.debug "params", params
      
      validate!
      execute!    
      reply
    end

    def on_reply
      Mastermind.logger.debug provider: type, action: action, params: params, fields: fields
    end

    def params
      workitem.fields['params']
    end
    
    def result_field
      workitem.fields['params']['result_field']
    end
    
    def result_field?
      !!result_field
    end
    
    def fields
      workitem.fields.except('params')
    end

    def action
      # params['ref'].split('_').first
      params['ref'].gsub("_#{type}", '')
      # workitem.field_or_param(:action)
    end
  end
end

Mastermind.dashboard.register_participant ", self
