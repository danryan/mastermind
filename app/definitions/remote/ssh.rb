Mastermind.define name: 'run_ssh' do
  filter 'command', type: 'string'
  filter 'host', type: 'string'
  filter 'user', type: 'string'
  filter 'key_data', type: 'string'
  
  ssh action: 'run',
    command: '${command}',
    host: '${host}',
    user: '${user}',
    key_data: '${key_data}'
end