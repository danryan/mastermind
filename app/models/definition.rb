class Definition
  
  attr_accessor :pdef
  
  def initialize(pdef)
    @pdef = pdef
  end

  def revision
    tree[1]['revision']
  end

  def tree
    Ruote::Reader.read(pdef)
  end

  def tree_json
    Rufus::Json.encode(tree)
  end

  def to_ruby
    Ruote::Reader.to_ruby(tree).strip
  end
  
  def to_param
    name
  end

  # needs fixing for multiple participant definitions
  # def attributes
  #   tree[2][-1][1].keys.reject{ |k|k == 'action' }
  # end
    
  def name
    tree[1]['name'] || tree[1].find { |k, v| v.nil? }.first
  end

  def as_json(options={})
    to_hash
  end
  
  def to_hash
    {
      name: name,
      revision: revision,
      pdef: pdef
    }
  end

end

