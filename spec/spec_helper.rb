require 'rubygems'
require 'spork'

Spork.prefork do 
  require 'rspec'
  
  support_files = File.join(File.expand_path(File.dirname(__FILE__)), "spec/support/**/*.rb")
  Dir[support_files].each {|f| require f}

  RSpec.configure do |config|
    #config.color_enabled = true
    config.mock_with :rspec
    config.before do
      $redis.flushdb
    end
  end
end

Spork.each_run do
  $: << File.join(File.dirname(__FILE__), "../lib")
  require 'mastermind'
end
