module Mastermind
  module AWS
    FLAVORS = ['m1.small', 'm1.medium', 'm1.large', 'm1.xlarge', 't1.micro', 'm2.xlarge', 'm2.2xlarge', 'm2.4xlarge', 'c1.medium', 'c1.xlarge', 'cc1.4xlarge', 'cc2.8xlarge', 'cg1.4xlarge', 'hi1.4xlarge']
    
    REGIONS = ['ap-northeast-1', 'ap-southeast-1', 'eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2', 'sa-east-1']
    
    ZONES = {
      'us-east-1' => [
        'us-east-1a', 'us-east-1b', 'us-east-1c', 'us-east-1d', 'us-east-1e'
      ],
      'us-west-1' => [
        'us-west-1a', 'us-west-1b', 'us-west-1c'
      ],
      'us-west-2' => [
        'us-west-2a', 'us-west-2b', 'us-west-2c'
      ],
      'ap-northeast-1' => [
        'ap-northeast-1a', 'ap-northeast-1b'
      ],
      'ap-southeast-1' => [
        'ap-southeast-1a', 'ap-southeast-1b'
      ],
      'eu-west-1' => [
        'eu-west-1a', 'eu-west-1b', 'eu-west-1c'
      ],
      'sa-east-1' => [
        'sa-east-1a', 'sa-east-1b'
      ]
    }

  end
end