Mastermind.define name: 'pass_mock' do
  mock action: 'pass',
       message: '${message}'
end

Mastermind.define name: 'fail_mock' do
  mock action: 'fail',
       message: '${message}'
end
