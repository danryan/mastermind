class Definition < ActiveRecord::Base
  attr_accessible :content, :name
  
  has_paper_trail
  
  validates :name, 
    presence: true, 
    uniqueness: true# ,
    #     format: { with: /[]}
  validates :content, 
    presence: true
    
  def to_pdef
    parse
  end
  
  def to_param
    name
  end
  
  def to_hash
    {
      name: name,
      content: content# ,
      # pdef: to_pdef
    }
  end
  
  def as_json(options={})
    to_hash
  end
  
  def define(attributes, &block)
    Ruote.define(attributes, &block)
  end
  
  private

  def parse
    # `instance_eval` our string
    # We pump it through #define first so the new Ruby 1.9 hash syntax gets
    # converted to hash rockets so Ruote doesn't choke.
    #
    self.instance_eval <<-EOF
self.define name: "#{name}" do
#{content}
end    
    EOF
  end
  
end
