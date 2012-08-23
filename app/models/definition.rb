class Definition < ActiveRecord::Base
  attr_accessible :definition

  serialize :definition, JSON

  before_save :update_name

  def revision
    tree[1]['revision']
  end

  def tree
    Ruote::Reader.read(definition)
  end

  def tree_json
    Rufus::Json.encode(tree)
  end

  def rubyize!
    Ruote::Reader.to_ruby(tree).strip
  end

  def jsonize!
    Ruote::Reader.to_json(tree).strip
  end
  
  private
  
  def _name
    tree[1]['name'] || tree[1].find { |k, v| v.nil? }.first
  end

  def update_name
    self.name = _name
  end
  
end

