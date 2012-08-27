# definitions should be class-based instead of a block in a file. 

class SSH < Pdef

  attr_reader :act
  
  def define
    
  end
  
end

class Pdef
  
  def self.attr_reader(*attrs)
    attrs.each do |attribute|
      class_eval do
        define_method attribute do
          @attrs[attribute.to_s]
        end
        define_method "#{attribute}=" do |value|
          @attrs[attribute.to_s] = value
        end
      end
    end
  end
  
  attr_reader :action
end