class FooPlot < Mastermind::Plot

  [ "foo.example.com", "bar.example.com" ].each do |server|
    ec2_instance server do
      action :create
      zone "us-east-1a"
    end

    chef_node server do
      action :create
      run_list [ "recipe[foo]", "recipe[bar]" ]
    end
  
    chef_client server do
      action :create
      admin true
    end
  end
  
end