module Mastermind
  class Provider
    class EC2 < Provider
      provider_name :ec2
      actions :nothing
      
      attribute :action, :default => :nothing
    end
  end
end