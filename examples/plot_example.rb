$: << File.join(File.dirname(__FILE__), "../lib")
require 'mastermind'

plot = Mastermind::Plot.new("foobar") do
  tasks do
    # ec2_server_create "wat" do
    #   # puts "WAT"
    # end
    
    task "foo" do
      # action :create
      provider Mastermind::Provider::EC2::Server
      # options({
      #   :availability_zone => "us-east-1a",
      #   :flavor_id => "t1.micro",
      #   :image_id => "ami-abcd1234",
      #   :key_name => "c2_test"
      # })
    end

    task "bar" do
      provider Mastermind::Provider::EC2::Server
      action :stop
      options({
        :availability_zone => "us-east-1b",
        :flavor_id => "m1.large",
        :image_id => "ami-1234abcd",
        :key_name => "c2_test"
      })
    end
    task "baz" do
      # action :stop
      provider Mastermind::Provider::EC2::Server
      action :destroy
      options({
        :availability_zone => "us-west-1a",
        :flavor_id => "m1.xlarge",
        :image_id => "ami-1234abcd",
        :key_name => "c2_test"
      })
    end
  end
end

# puts Mastermind::Provider.registry

plot.run