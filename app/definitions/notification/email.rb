Mastermind.define name: 'notify_email' do
  filter 'subject', type: 'string'
  filter 'body', type: 'string'
  filter 'from', type: 'string'
  filter 'to', type: 'string'
  
  email action: 'notify',
    subject: '${subject}',
    body: '${body}',
    from: '${from}',
    to: '${to}'
    
end