module Mastermind
  class Resource
    include Mixin::Attributes
    include Mixin::Resources

    attribute :provider, Class
    attribute :default_action, Symbol, :default => :create
    
  end
end