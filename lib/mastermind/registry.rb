module Mastermind
  class Registry
    def initialize
      @registered = Hash.new.with_indifferent_access
    end

    def register(key, value)
      @registered[key] = value
    end

    def get(key)
      return nil unless @registered.has_key?(key)
      return @registered[key]
    end
    alias :[] :get

    def has_key?(key)
      @registered.has_key?(key)
    end

    def keys
      @registered.keys
    end

    def to_hash
      @registered
    end

    def each
      @registered.each do |key, _|
        yield key, get(key)
      end
    end

  end
end
