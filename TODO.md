# bootstrapping a new node

job = Job.new({
  name: "create and destroy an instance",
  definition: "create and destroy an instance",
  fields: {
    flavor_id: "t1.micro",
    image_id: "ami-fe5bd4ce",
    region: "us-west-2",
    availability_zone: "us-west-2a",
    key_name: "storm",
    groups: [ "default" ],
    tags: { 'Name' => "foo.example.com" }
  }
})

wfid = Mastermind.launch(job)
ps = Mastermind.ps(wfid)

# with per-task field overrides

# job holds multiple tasks
# task maps to a ruote definition
# job fields are deep-merged to task fields
# task is launched
# results of task are stored in task.result
# 
# job results is hash of task results
# 
# Job.build_pdef

Mastermind.define name: "passing mock" do
  pass_mock :message => "${message}"
end

j = Job.new({
  name: "passing!",
  definition: "passing mock",
  fields: {
    message: "FOOOOOOO"
  }
})

wfid = Mastermind.launch(j.pdef, j.fields)
ps = Mastermind.ps(wfid)


fields = {
  image_id: 'ami-fe5bd4ce',
  flavor_id: 't1.micro',
  key_name: 'storm',
  region: 'us-west-2',
  availability_zone: 'us-west-2a',
  groups: [ "default" ],
  tags: { 'Name' => 'foo.bar.com' }
}

pdef = Ruote.define do
  create_ec2_server image_id: '${image_id}',
    flavor_id: '${flavor_id}',
    key_name: '${key_name}',
    region: '${region}',
    availability_zone: '${availability_zone}',
    groups: '$f:groups',
    tags: '$f:tags'
    
  notify_campfire message: "${instance_id} created!"
  
  destroy_ec2_server instance_id: '${instance_id}',
    region: '${region}'
    
  notify_campfire message: "${instance_id} destroyed!"
end

wfid = Mastermind.launch(pdef, fields)