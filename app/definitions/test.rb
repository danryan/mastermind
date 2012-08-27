Mastermind.define name: 'test' do
  citerator on: '$f:servers', to: 'server', merge: :highest, merge_type: :isolate do
    ec2_server action: 'create',
               image_id: '${f:server.image_id}',
               flavor_id: '${f:server.flavor_id}',
               key_name: '${f:server.key_name}',
               region: '${f:server.region}',
               availability_zone: '${f:server.availability_zone}',
               groups: '$f:server.groups',
               tags: '$f:server.tags'
    
  end         
end