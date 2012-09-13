module Mastermind
  class Resource
    class Mock < Resource
      register :mock
      provider Mastermind::Provider::Mock
      actions :pass, :modify, :fail
      
      attribute :message, :type => String

      [ :pass, :modify ].each do |act|
        validates! :message,
          :presence => true,
          :on => act
      end
    end
  end
end
