Mastermind.define name: 'passing mock' do
  pass_mock message: '${message}'
end

Mastermind.define name: 'modifying mock' do
  modify_mock message: '${message}'
end

# Mastermind.define name: 'pass_mock' do
#   mock action: 'pass',
#     message: '${message}'
# end
# 
# Mastermind.define name: 'modify_mock' do
#   mock action: 'modify',
#     message: '${message}'
# end
# 
# Mastermind.define name: 'fail_mock' do
#   mock action: 'fail',
#     message: '${message}'
# end
