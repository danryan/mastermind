create_ec2_server image_id: '${image_id}',
  flavor_id: '${flavor_id}',
  key_name: '${key_name}',
  region: '${region}',
  availability_zone: '${availability_zone}',
  groups: '$f:groups', 
  tags: '$f:tags'

# ${instance_id} is a field added by the `create_ec2_server` action
notify_campfire message: "${instance_id} created!"

destroy_ec2_server instance_id: '${instance_id}', region: '${region}'

notify_campfire message: "${instance_id} destroyed!"