# bootstrapping a new node
{
  name: "create and destroy a new node",
  tasks: [
    "create_ec2_server",
    "set :message => '${instance_id} created!'",
    "notify_campfire",
    "destroy_ec2_server",
    "set :message => '${instance_id} destroyed!'",
    "notify_campfire"
  ],
  fields: {
    flavor_id: "t1.micro",
    image_id: "ami-fe5bd4ce",
    region: "us-west-2",
    availability_zone: "us-west-2a",
    key_name: "storm",
    groups: [ "default" ],
    tags: { 'Name' => "foo.example.com" }
  }
}

# with per-task field overrides

{
  name: "create and destroy a new node",
  tasks: [
    :create_ec2_server,
    :notify_campfire => { :message => '${instance_id} created!' },
    :destroy_ec2_server,
    :notify_campfire => { :message => '${instance_id} destroyed!' }
  ],
  fields: {
    flavor_id: "t1.micro",
    image_id: "ami-fe5bd4ce",
    region: "us-west-2",
    availability_zone: "us-west-2a",
    key_name: "storm",
    groups: [ "default" ],
    tags: { 'Name': "foo.example.com" },
    message: "${instance_id} created!"
  }
}


63b62950
{
  name: "destroy a node",
  tasks: [
    "destroy_ec2_server",
    "notify_campfire"
  ],
  fields: {
    instance_id: "i-63b62950",
    region: "us-west-2",
    message: "${instance_id} destroyed!"
  }
}

# mock job

{
  name: "mock job",
  tasks: [
    "pass_mock",
    "pass_mock",
    "pass_mock"
  ],
  fields: {
    message: "#{["foo", "bar", "baz"].sample}!"
  }
}

job holds multiple tasks
task maps to a ruote definition
job fields are deep-merged to task fields
task is launched
results of task are stored in task.result

job results is hash of task results

Job.build_pdef