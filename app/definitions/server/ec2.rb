Mastermind.define name: 'create_ec2_server' do
  set 'action' => 'create'
  ec2_server
end

Mastermind.define name: 'destroy_ec2_server' do
  set 'action' => 'destroy'
end

Mastermind.define name: 'stop_ec2_server' do
  set 'action' => 'stop'
end

Mastermind.define name: 'start_ec2_server' do
  set 'action' => 'start'
end

Mastermind.define name: 'restart_ec2_server' do
  set 'action' => 'restart'
end
