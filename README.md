# Mastermind

We need more than "ssh-in-a-for-loop". Our infrastructure get more complex every day and we need a tool that can choreograph an intricate dance of services, servers and commands in a manageable way.

Mastermind is an _infrastructure orchestration engine_. Its purpose is to provide the ability to compose and automate complex tasks with predefined and reproducible outcomes.

Mastermind uses a special domain-specific language for its process definitions, but if you're familiar with [Ruby](http://www.ruby-lang.org/), it should feel right at home.

# Using Mastermind

Here's an example of a basic sysadmin workflow, as implemented by Mastermind. Here, we create and destroy an EC2 instance, while notifying a Campfire room of each action performed.

```ruby
definition = Definition.new({
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
  definition: "create_and_destroy_ec2_server",
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

## Job

A job is a template, tied to a definition. Jobs launch workflows.

### Attributes

* name (String) - The name of the job.
* definition (String) - The name of the definition that this job will launch.
* fields (Hash) - The initial attributes used by the definition, and ultimately each participant.

### Example job

```ruby
job = Job.new({
  name: "do the needful",
  definition: "execute remote ssh",
  fields: {
    host: "db-master.example.com",
    user: "root",
    key_data: "-----BEGIN RSA PRIVATE KEY-----\n-----END RSA PRIVATE KEY-----"
    command: "rm -rf /"
  }
})
```

## Definition

A definition is the workflow itself. It's the document that describes exactly what tasks will be performed, and in what order.

### Attributes

* name (String) - The name of the definition.
* content (Array) - The process definition.

### Dollar notation ${...}

Mastermind scans strings in process definition for `${...}` placeholders and substitutes them for fields provided by the job or fields added by participants during the execution of the process. Any field interpolated by `${...}` will be the string representation of the value. If the literal value of the field is needed (for instance, if a field holds an array of values), use the `$f:` notation instead.

Given the job fields:

```ruby
{
  :name => "Dan Ryan",
  :titles => [ "Future Mayor of Lansing, MI", "Thoulght Leader" ]
}
```

The following definition...:

```ruby
person :name => "${name}", :titles => "$f:titles"
```

...gets compiled to:

```ruby
person :name => "Dan Ryan", :titles => [ "Future Mayor of Lansing, MI", "Thoulght Leader" ]
```

## Example definition

```ruby
Definition.new(
  :name => "standard syntax",
  :content => %q{
    run_ssh host:     '${host}',
            user:     '${user}',
            key_data: '${key_data}',
            command:  '${command}'
  }
).to_pdef

# => compiled definition
#
# ["define",
#  {"name"=>"watee"},
#  [["run_ssh",
#    {"host"=>"${host}",
#     "user"=>"${user}",
#     "key_data"=>"${key_data}",
#     "command"=>"${command}"},
#    []]]]
```

The previous example uses Ruby 1.9-style hash syntax. If you prefer the look of the "hash rocket", you are more than welcome to use it instead!

```ruby
Definition.new(
  :name => "hash rockets",
  :content => %q{
    run_ssh :host     => '${host}', 
            :user     => '${user}', 
            :key_data => '${key_data}', 
            :command  => '${command}'
  }
).to_pdef

# => compiled definition
#
# ["define",
#  {"name"=>"watee"},
#  [["run_ssh",
#    {"host"=>"${host}",
#     "user"=>"${user}",
#     "key_data"=>"${key_data}",
#     "command"=>"${command}"},
#    []]]]
```

You can even mix in plain old Ruby if you're feeling adventurous!
```ruby
hosts = %w( host1.example.com host2.example.com host3.example.com )

Definition.new(
  :name => "plain ol' ruby!",
  :content => %q{
    hosts = %w( host1.example.com host2.example.com host3.example.com )
    hosts.each do |host|
      run_ssh :host     => host, 
              :user     => '${user}', 
              :key_data => '${key_data}', 
              :command  => '${command}'
    end
  }
).to_pdef

# Same as:
Definition.new(
  :name => "plain ol' ruby!",
  :content => %q{
    run_ssh :host     => "host1.example.com", 
            :user     => '${user}', 
            :key_data => '${key_data}', 
            :command  => '${command}'
    run_ssh :host     => "host2.example.com", 
            :user     => '${user}', 
            :key_data => '${key_data}', 
            :command  => '${command}'
    run_ssh :host     => "host3.example.com", 
            :user     => '${user}', 
            :key_data => '${key_data}', 
            :command  => '${command}'
  }
).to_pdef

# => compiled definition
#
# ["define",
#  {"name"=>"watee"},
#  [["run_ssh",
#    {"host"=>"host1.example.com",
#     "user"=>"${user}",
#     "key_data"=>"${key_data}",
#     "command"=>"${command}"},
#    []],
#   ["run_ssh",
#    {"host"=>"host2.example.com",
#     "user"=>"${user}",
#     "key_data"=>"${key_data}",
#     "command"=>"${command}"},
#    []],
#   ["run_ssh",
#    {"host"=>"host3.example.com",
#     "user"=>"${user}",
#     "key_data"=>"${key_data}",
#     "command"=>"${command}"},
#    []]]]
```

## Participant

A participant is responsible for performing tasks as specified by the definition. There are many types of participants. A participant can provision a server, send notifications, or even execute remote commands.

### Attributes

Participant attributes vary depending on their purpose.

### Example participant

```ruby
require 'net/ssh'

module Participant::Remote
  class SSH < Participant
    register :ssh
    
    action :run do
      requires :host, :user, :key_data, :command
      
      target.output = run_ssh(target.command)
      return {}
    end

    def run_ssh(command)
      session = Net::SSH.start(target.host, target.user, { key_data: target.key_data })
      output = nil

      session.open_channel do |ch|
        ch.request_pty
        ch.exec command do |ch, success|
          raise ArgumentError, "Cannot execute #{target.command}" unless success
          ch.on_data do |ichannel, data|
            output = data
          end
        end
      end

      session.loop
      session.close
      return output if output
    end
  end
end
```

## Target

A target is the resource that the participant modifies. The target can have a variety of attributes, depending on the participant's needs. The target performs the majority of validations to ensure the participant has the right fields to execute its actions.

### Attributes

Target attributes vary depending on their purpose.

### Example target

```ruby
# Modules are used as namespaces.
module Target::Remote

  # All targets inherit from Target
  class SSH < Target
  
    # We'll refer to this target elsewhere by the name we use to register it.
    register :ssh

    # Various attributes of the target. The :type option typecasts the attribute.
    attribute :command, type: String
    attribute :host, type: String
    attribute :user, type: String
    attribute :key_data, type: String  
    attribute :output, type: String
    
    # Validate the target to ensure we have the right details.
    validates! :command, :host, :user, :key_data,
      presence: true
  end
end
```

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