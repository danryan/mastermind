$: << File.join(File.dirname(__FILE__), "../lib")
require 'mastermind'

plot = Mastermind::Plot.new("foobar") do
  tasks do
    # ec2_server_create "wat" do
    #   # puts "WAT"
    # end
    
    # task "foo" do
    #   # action :create
    #   provider Mastermind::Provider::EC2::Server
    #   options({
    #     :availability_zone => ["asdf", "asdf"],
    #     :flavor_id => "t1.micro",
    #     :image_id => "ami-abcd1234",
    #     :key_name => "c2_test"
    #   })
    # end
    # 
    # task "bar" do
    #   provider Mastermind::Provider::EC2::Server
    #   action :stop
    #   options({
    #     :availability_zone => "us-east-1b",
    #     :flavor_id => "m1.large",
    #     :image_id => "ami-1234abcd",
    #     :key_name => "c2_test"
    #   })
    # end
    # task "baz" do
    #   # action :stop
    #   provider Mastermind::Provider::EC2::Server
    #   action :destroy
    #   options({
    #     :availability_zone => "us-west-1a",
    #     :flavor_id => "m1.xlarge",
    #     :image_id => "ami-1234abcd",
    #     :key_name => "c2_test"
    #   })
    # end

    ec2_server do
      flavor_id 't1.micro'
      image_id 'ami-1234abcd'
    end
    
    ec2_server do 
      action :destroy
    end
  end
end

# puts Mastermind::Provider.registry

plot.run

# plot.tasks.each do |task|
#   p = task.provider.new(task.options)
#   puts p.attributes
#   puts p.task_list
# end

# provider = Mastermind::Provider.find_by_name(:ec2_server)
# puts provider.new(:foo => "Bar", :flavor_id => "delicious").inspect
# provider.flavor_id "delicious"
# puts provider.instance_methods(false)

# puts Mastermind::TaskList.instance_methods(false)
provider = Mastermind::Provider::EC2::Server
# # provider.foo = :create
# 
# p = provider.new(:foo => :bar, :action => :create)
# puts "Class attributes"
# puts provider.attributes.inspect
# puts
# puts "Instance attributes"
# puts p.attributes.inspect
# puts p.foo.inspect
# puts p.action
# puts provider.actions.inspect
# puts p.run

# puts provider.default_action




# Mastermind::Provider.find_by_name(:ec2_server).action