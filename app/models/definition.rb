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

  def to_json
    Ruote::Reader.to_json(tree).strip
  end
  
  def to_param
    name
  end
  
  def attributes
    tree[2][-1][1].keys.reject{ |k|k == 'action' }
  end
    
  def name
    tree[1]['name'] || tree[1].find { |k, v| v.nil? }.first
  end

end

