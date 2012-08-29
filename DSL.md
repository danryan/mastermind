# Define a workflow. Order matters. 

define :name => "create and destroy an instance" do
  create_ec2_server do
    image_id '${image_id}'
    flavor_id '${flavor_id}'
    key_name '${key_name}'
    region '${region}'
    availability_zone '${availability_zone}'
    groups '$f:groups'
    tags '$f:tags'
  end
  
  notify_campfire do
    message '${instance_id} created!'
  end
  
  destroy_ec2_server do
    instance_id '${instance_id}'
    region '${region}'
  end
  
  notify_campfire do
    message "${instance_id} destroyed!"
  end
end

job = Job.new({
  name: "new ec2 instance workflow",
  definition: "create and destroy an instance",
  fields: {
    flavor_id: "m1.large",
    image_id: "ami-abcd1234",
    region: "us-east-1",
    availability_zone: "us-east-1a",
    key_name: "default",
    groups: [ "default" ],
    tags: { 'Name' => "foo.example.com" }
  }
})

Mastermind.launch(job)