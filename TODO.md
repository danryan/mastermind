{
  name: "bootstrap a new node",
  tasks: [
    { definition: "create_ec2_server" },
    { definition: "bootstrap_chef" },
    { definition: "notify_campfire" }
  ]
  fields: {
    flavor_id: "m1.large",
    image_id: "ami-1234abcd",
  }
}

job holds multiple tasks
task maps to a ruote definition
job fields are deep-merged to task fields
task is launched
results of task are stored in task.result

job results is hash of task results