# Mastermind

We need more than "ssh-in-a-for-loop". Our infrastructure gets more complex every day and we need a tool that can choreograph an intricate dance of services, servers, and commands in a manageable way.

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

## providers

See [providers in the wiki](https://github.com/danryan/mastermind/wiki/providers)

## resources

See [resources in the wiki](https://github.com/danryan/mastermind/wiki/resources)

# Dependencies

* Ruby >= 1.9.2
* [Ruote](http://ruote.rubyforge.org)
* [PostgreSQL](http://www.postgresql.org)
* [Redis](http://redis.io)

Mastermind uses PostgreSQL to store jobs and process definitions, Redis as a queue for workflow processes, and Ruote as the underlying "operating system" for workflow execution.

# Configuration

Mastermind uses the following environment variables for configuration:

## Mastermind settings

* `MASTERMIND_NOISY` - Whether workflow debug info should be emitted to the logs. Default is `false`.
* `MASTERMIND_LOG_LEVEL`="info" - The Mastermind log level. Default is `info`.
 
## AWS providers

* `AWS_ACCESS_KEY_ID` - AWS access key id
* `AWS_SECRET_ACCESS_KEY` - AWS secret access key

## Campfire participant

* `CAMPFIRE_ROOM` - Campfire room ID
* `CAMPFIRE_ACCOUNT` - Campfire account name
* `CAMPFIRE_TOKEN` - Campfire API token

## Chef providers 
* `CHEF_SERVER_URL` - Chef server URL. Remember to include the port if applicable.
* `CHEF_CLIENT_NAME` - Chef client name
* `CHEF_CLIENT_KEY` - Chef client key (the key itself, not the path). Example: `cat /Users/admin/.chef/admin.pem`

# Deployment

## Heroku

```bash
heroku create -s cedar
heroku addons:add heroku-postgresql:dev
heroku pg:promote HEROKU_POSTGRESQL_DEV_NAME
heroku addons:add redistogo
heroku config:set MASTERMIND_NOISY=[...]
heroku config:set MASTERMIND_LOG_LEVEL=[...]
heroku config:set AWS_ACCESS_KEY_ID=[...]
heroku config:set AWS_SECRET_ACCESS_KEY=[...]
heroku config:set CAMPFIRE_ACCOUNT=[...]
heroku config:set CAMPFIRE_ROOM=[...]
heroku config:set CAMPFIRE_TOKEN=[...]
heroku config:set CHEF_SERVER_URL=[...]
heroku config:set CHEF_CLIENT_NAME=[...]
heroku config:set CHEF_CLIENT_KEY=[...]
git push heroku master
heroku run rake db:migrate
heroku scale web=1
heroku scale worker=1
```

# API

Mastermind provides a REST-ish JSON API for job and definition management. Please see the [API wiki](https://github.com/danryan/mastermind/wiki/API) for details.

# API Client

```ruby
raise NotImplementedError, "Documentation coming soon!"
```

# Custom providers/resources 

```ruby
raise NotImplementedError, "Documentation coming soon!"
```
