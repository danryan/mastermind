Mastermind.define name: 'create_ec2_server' do
  filter 'image_id', type: 'string', smatch: '^ami-[a-f0-9]{8}$'
  filter 'flavor_id', in: Mastermind::AWS::FLAVORS
  filter 'key_name', type: 'string'
  filter 'groups', type: 'array<string>'
  filter 'tags', type: 'hash'
  filter 'availability_zone', :in => Mastermind::AWS::ZONES.map{ |k,v| v }.flatten
  # filter 'region', in: Mastermind::AWS::ZONES.keys
  
  ec2_server action: 'create',
    image_id: '${image_id}',
    flavor_id: '${flavor_id}',
    key_name: '${key_name}',
    region: '${region}',
    availability_zone: '${availability_zone}',
    groups: '$f:groups',
    tags: '$f:tags'
end

Mastermind.define name: 'destroy_ec2_server' do
  filter 'instance_id', type: 'string', smatch: '^i-[a-f0-9]{8}$'

  ec2_server action: 'destroy',
    instance_id: '${f:instance_id}'
end

Mastermind.define name: 'stop_ec2_server' do
  filter 'instance_id', type: 'string', smatch: '^i-[a-f0-9]{8}$'

  ec2_server action: 'destroy',
    instance_id: '${f:instance_id}'
end

Mastermind.define name: 'start_ec2_server' do
  filter 'instance_id', type: 'string', smatch: '^i-[a-f0-9]{8}$'
  
  ec2_server action: 'start',
    instance_id: '${f:instance_id}'
end

Mastermind.define name: 'restart_ec2_server' do
  filter 'instance_id', type: 'string', smatch: '^i-[a-f0-9]{8}$'
  
  ec2_server action: 'restart',
    instance_id: '${f:instance_id}'
end
