module Mastermind
  class Provider
    include Mixin

    provider_name :default
    actions :nothing
    
    # attribute :action
    attribute :foo, :type => :string
    
    default_action :nothing
    
    def initialize(options={})
      attributes_init(options)
      # puts attributes.inspect
      # generate_actions
    end

    def nothing
      puts "Nothing happened."
    end
    
    def task_list(value=nil)
      set_or_get(:task_list, value)
    end
    
    def self.find_by_name(name)
      Mastermind::Registry.list[name]
    end
    
    def run
      run_validations
    end

  end
end


