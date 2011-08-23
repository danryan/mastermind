module Mastermind
  class Provider
    include Mixin

    provider_name :default
    actions :nothing
    
    default_action :nothing
    
    attribute :name, :type => :string
    
    def initialize(options={})
      attributes_init(options)
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
    
    def execute
      run_validations
      self.send(self.action)
    end

  end
end


