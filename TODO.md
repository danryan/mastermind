# Allow specifying of a custom key in which to hold participant results.

participants are refactored into a single generic class
the participant actions are put into Providers.
the generic participant 
 * is handed the resource attributes
 * looks up the participant
 * runs the action
 * reports 
 

## How to do concurrent actions?
- Do we care?

use case: ssh runs over multiple hosts

participants watch a amqp for incoming requests. ??


## random

participant -> provider

dsl for resources

    create_ec2_server "foo" do
      # ...etc
    end

dsl compiles to resource
- resource runs action
- sends to provider
- provider executes action by sending it to ruote
  - ruote handles complexity like failures, rollbacks, cancels, etc.
  
- and returns an object 
 - ec2_server create returns an ec2 server object
 - list chef nodes returns an array of chef nodes

Resources
- dollar notation still works 
- resources are run in order
 - resources have access to the attributes of other resources
   - only after said resource has executed
   - accessed by the name of the resource

Definitions and their compiled pdefs are no longer exposed in the API. They are still used, but fully behind the scenes. Instead, resources are created with a DSL similar to that of 

- No more global workitem. mastermind compiles all resources, interpolates values at runtime, sends each resource off to ruote and adds the returned values to the specific resource

{ 
  'name' => {
    'first' => "Dan",
    'last' => "Ryan"
  }
}


