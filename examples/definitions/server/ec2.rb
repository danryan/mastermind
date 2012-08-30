# Mastermind.define name: 'create ec2 server' do
#   create_ec2_server image_id: '${image_id}',
#     flavor_id: '${flavor_id}',
#     key_name: '${key_name}',
#     region: '${region}',
#     availability_zone: '${availability_zone}',
#     groups: '$f:groups',
#     tags: '$f:tags'
# end
# 
# 
# 


# Mastermind.define name: 'destroy_ec2_server' do
#   ec2_server action: 'destroy',
#     instance_id: '${instance_id}',
#     region: '${region}'
#     
# end
# 
# Mastermind.define name: 'stop_ec2_server' do
#   ec2_server action: 'destroy',
#     instance_id: '${instance_id}',
#     region: '${region}'
#     
# end
# 
# Mastermind.define name: 'start_ec2_server' do
#   ec2_server action: 'start',
#     instance_id: '${instance_id}',
#     region: '${region}'
#     
# end
# 
# Mastermind.define name: 'restart_ec2_server' do
#   ec2_server action: 'restart',
#     instance_id: '${instance_id}',
#     region: '${region}'
#     
# end
