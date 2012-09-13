module Mastermind::Reader
  
  def self.read(file)
    read_file = File.open(file).read
  end
end