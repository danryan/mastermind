require 'mastermind/dsl/member'

module Mastermind::DSL
  class Compiler
    class << self
      def generate(*args, &block)
        options = args.extract_options!
        compiler = self.new(options)
        compiler.compile(*args, &block)
        compiler.finalize
      end
    end
    
    attr_accessor :members
    attr_accessor :array
    attr_accessor :scope
    attr_accessor :callback
    attr_accessor :pretty_print
    
    def initialize(options={})
      @_members = []
      @_scope = options.fetch(:scope, nil)
      @_callback = options.fetch(:callback, true)
      @_pretty_print = options.fetch(:pretty, false)
      
      copy_instance_variables_from(@_scope) if @_scope
    end
    
    def compile(*args, &block)
      instance_exec(*args, &block)
    end
    
    def array()
      
    end
    
    def method_missing(key_name, *args, &block)
      if @_scope.respond_to?(key_name) && !ignore_scope_methods.include?(key_name)
        @_scope.send(key_name, *args, &block)
      else
        key(key_name, *args, &block)
      end
    end
    
    def key(key_name, *args, &block)
      member = Member.new(key_name, @_scope, *args, &block)
      @_members << member
      member
    end
    
    def finalize
      include_callback to_s
    end
    
    def to_s
      @_array ? @_array.to_s : "{#{@_members.collect(&:to_s).join(', ')}}"
    end
    
    private
    
    def include_callback(json)
      @_callback && request_params[:callback] ? "#{request_params[:callback]}(#{pretty_print(json)})" : pretty_print(json)
    end
    
    def pretty_print(json)
      @_pretty_print ? JSON.pretty_generate(JSON[json]) : json
    end
    
    def request_params
      @_scope.respond_to?(:params) ? @_scope.params : {}
    end
    
    def copy_instance_variables_from(object, exclude = []) #:nodoc:
      vars = object.instance_variables.map(&:to_s) - exclude.map(&:to_s)
      vars.each { |name| instance_variable_set(name.to_sym, object.instance_variable_get(name)) }
    end
    
    def ignore_scope_methods
      [:id]
    end
    
  end
end