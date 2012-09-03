# Mastermind

We need more than "ssh-in-a-for-loop". Our infrastructure get more complex every day and we need a tool that can choreograph an intricate dance of services, servers and commands in a manageable way.

Mastermind is an _infrastructure orchestration engine_. Its purpose is to provide the ability to compose and automate complex tasks with predefined and reproducible outcomes.

Mastermind uses a special domain-specific language for its process definitions, but if you're familiar with [Ruby](http://www.ruby-lang.org/), it should feel right at home.

# Using Mastermind

Here's an example of a basic sysadmin workflow, as implemented by Mastermind. Here, we create and destroy an EC2 instance, while notifying a Campfire room of each action performed.

```ruby
defn = Definition.create({
  name: "create_and_destroy_ec2_server",
    content: %q{
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
  }
})

job = Job.new({
  name: "new ec2 instance workflow",
  definition: defn,
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

job.launch
```

Mastermind has four basic pieces: a job; a definition; a participant; and a target.

## Jobs

See [Jobs in the wiki](https://github.com/danryan/mastermind/wiki/Jobs)

## Participants

See [Participants in the wiki](https://github.com/danryan/mastermind/wiki/Participants)

## Targets

See [Targets in the wiki](https://github.com/danryan/mastermind/wiki/Targets)

# Dependencies

* Ruby >= 1.9.2
* [Ruote](http://ruote.rubyforge.org)
* [PostgreSQL](http://www.postgresql.org)
* [Redis](http://redis.io)

Mastermind uses PostgreSQL to store jobs and process definitions, Redis as a queue for workflow processes, and Ruote as the underlying "operating system" for workflow execution.

# API

```ruby
raise NotImplementedError, "Documentation coming soon!"
```

# Custom participants/targets 

```ruby
raise NotImplementedError, "Documentation coming soon!"
```