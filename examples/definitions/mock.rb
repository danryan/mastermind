Mastermind.define name: 'passing mock' do
  pass_mock message: '${message}'
end

Mastermind.define name: 'modifying mock' do
  modify_mock message: '${message}'
end

# Mastermind.define name: 'fail mock' do
#   fail_mock action: 'fail',
#     message: '${message}'
# end
