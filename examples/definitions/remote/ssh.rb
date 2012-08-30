Mastermind.define name: 'ssh' do
  run_ssh command: '${command}',
    host: '${host}',
    user: '${user}',
    key_data: '${key_data}'
end