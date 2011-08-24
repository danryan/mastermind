We need more than "ssh-in-a-for-loop" orchestration. Our infrastructure get more complex every day and we need a tool that can choreograph an intricate dance of services, servers and commands in a easily manageable way.

## Providers

So far this list is incomplete and not fully implemented, but it does show the list of expected resources that Mastermind will be able to orchestrate once it's ready for primetime (with more to follow as requirements dictate).

### Servers

* EC2
* Rackspace
* Linode

### DNS

* Route53
* DNSimple
* Dynect
* Linode

### Configuration Management

* Puppet
* Chef

### Remote

* SSH
* HTTP
* XMPP

## Usage

    ./bin/mastermind <plot_file_path>

## Example Plotfile

    app_servers = [ 'app0.example.com', 'app1.example.com', 'app2.example.com', 'app3.example.com' ]
    db_servers = [ 'db0.example.com', 'db1.example.com', 'db2.example.com', 'db3.example.com' ]

    servers = app_servers + db_servers

    web_servers.each do |server|
      ec2_server server do
        flavor_id 'm1.large'
        image_id 'ami-1aad5273'
        availability_zone 'us-east-1a'
        aws_access_key_id 'access_key'
        aws_secret_access_key 'sekret_key'
        tags 'Name' => name
        key_name 'ec2_production'
        groups [ 'app_server', 'base' ]
      end
    end

    db_servers.each do |server|
      ec2_server server do
        flavor_id 'm1.xlarge'
        image_id 'ami-1aad5273'
        availability_zone 'us-east-1a'
        aws_access_key_id 'access_key'
        aws_secret_access_key 'sekret_key'
        tags 'Name' => name
        key_name 'ec2_production'
        groups [ 'db_server', 'base' ]
      end
    end
  
    servers.each do |server|
      chef_client server do
        admin false
      end
  
      chef_node server do
        action :create
        run_list [ "recipe[foo]", "recipe[bar]" ]
      end
  
      route53_record server do
        zone 'zone-id-fooo'
        value server.public_dns_name
        type 'CNAME'
        ttl 300
      end
    end