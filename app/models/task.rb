class Task
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :resources
end
