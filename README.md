# Mastermind

We need more than "ssh-in-a-for-loop" orchestration. Our infrastructure get more complex every day and we need a tool that can choreograph an intricate dance of services, servers and commands in a manageable way.

## Intro

Mastermind is an _ infrastructure workflow engine_. Its purpose is to provide the ability to compose and automate complex tasks with predefined and reproducible outcomes.

Mastermind has four basic pieces: a job; a definition; a participant; and a target.

### Job

A job is a template, tied to a definition. Jobs launch workflows.

#### Attributes

* name (String) - The name of the job.
* definition (String) - The name of the definition that this job will launch.
* fields (Hash) - The initial attributes used by the definition, and ultimately each participant.


### Definition

A definition is the workflow itself. It's the document that describes exactly what tasks will be performed, and in what order.

#### Attributes

* name (String) - The name of the definition.
* pdef (Array) - The compiled process definition.


#### Dollar notation ${...}

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
define :name => "assign titles" do
  person :name => "${name}", :titles => "$f:titles"
end
```

...gets compiled to:

```ruby
define :name => "assign titles" do
  person :name => "Dan Ryan", :titles => [ "Future Mayor of Lansing, MI", "Thoulght Leader" ]
end
```

### Participant

A participant is responsible for performing tasks as specified by the definition. There are many types of participants. A participant can provision a server, send notifications, or even execute remote commands.

#### Attributes

Participant attributes vary depending on their purpose.

### Target

A target is the resource that the participant modifies. The target can have a variety of attributes, depending on the participant's needs. The target performs the majority of validations to ensure the participant has the right fields to execute its actions.

#### Attributes

Target attributes vary depending on their purpose.

### Example - Create and destroy an EC2 instance, while notifying a Campfire room of each action performed.


## Example

Here's a brief sample of a common workflow, as implemented by Mastermind, that can be created from within a Rails console:


```ruby
job = Job.new({
  name: "new ec2 instance workflow",
  definition: "create and destroy an instance",
  fields: {
    flavor_id: "m1.large",
    image_id: "ami-abcd1234",
    region: "us-east-1",
    availability_zone: "us-east-1a",
    key_name: "default",
    groups: [ "default" ],
    tags: { 'Name' => "foo.example.com" }
  }
})

Mastermind.define :name => "create and destroy an instance" do
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
end

Mastermind.launch(job)
```

## Dependencies

* Ruby >= 1.9.2
* [Ruote](http://ruote.rubyforge.org)
* [PostgreSQL](http://www.postgresql.org)
* [Redis](http://redis.io)

Mastermind uses PostgreSQL to store information about jobs, Redis as a queue for workflow processes, and Ruote as the underlying "operating system" for workflow execution.

## API

```ruby
raise NotImplementedError, "Documentation coming soon!"
```

## Custom participants/targets 

```ruby
raise NotImplementedError, "Documentation coming soon!"
```