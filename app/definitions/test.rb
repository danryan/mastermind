Mastermind.define name: 'test' do
  set 'availability_zones' => "${r:Mastermind::AWS::ZONES[d('region')].join(', ')}"
  echo '${availability_zones}'
  filter 'availability_zone', :in => Mastermind::AWS::ZONES.map{ |k,v| v }.flatten
end