

    define name: create_ec2_server
      ec2_server action: 'create',
                 image_id: '${f:image_id}',
                 flavor_id: '${f:flavor_id}',
                 key_name: '${f:key_name}',
                 availability_zone: '${f:availability_zone}',
                 groups: '$f:groups',
                 tags: '$f:tags'
                 
                 
                 
                 