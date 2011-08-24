module Mastermind
  module Mixin
    module Validations
      extend ActiveSupport::Concern
      
      include ::ActiveModel::Validations
      include ::ActiveMOdel::Validations::Callbacks
      
      module ClassMethods
        
      end
      
      module InstanceMethods
      end
    end
  end
end