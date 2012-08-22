source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# JSON
gem 'json', :platform => :jruby
gem 'multi_json', '~> 1.3.6'
gem 'yajl-ruby', :platform => [ :ruby_18, :ruby_19 ]

# OpenSSL
gem 'jruby-openssl', :platform => :jruby

gem 'ruote', git: 'https://github.com/jmettraux/ruote.git'
gem 'ruote-redis', git: 'https://github.com/jmettraux/ruote-redis.git'
gem 'ruote-kit'

gem 'active_attr', '~> 0.6.0'

# Logging
gem 'cabin', '~> 0.4.4'

# Support libraries for participants
gem 'fog', '~> 1.5.0'

# Queue processing
gem 'sidekiq', '~> 2.1.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do 
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do
  gem 'rspec-rails', '>= 2.10.0'
  gem 'factory_girl_rails', '>= 3.2.0'
  gem 'shoulda-matchers', '>= 1.0.0'
  gem 'capybara', '>= 1.1.2'
  gem 'rack-test', '>= 0.6.0', :require => 'rack/test'
  gem 'json_spec', '>= 1.0.3'
  gem 'email_spec', '>= 1.2.1'
  gem 'spork', '>= 1.0.0rc2'
  gem 'guard', '>= 1.0.3'
  gem 'guard-rails', '>= 0.1.0'
  gem 'guard-rspec', '>= 0.7.2'
  gem 'guard-spork', '>= 0.8.0'
  gem 'guard-bundler'
  gem 'rb-fsevent', '>= 0.9.1'
  gem 'growl', '>= 1.0.3'
  gem 'database_cleaner', '>= 0.7.2'
  gem 'tach', ">= 0.0.8"
  gem 'forgery', '>= 0.5.0'
  gem 'timecop', '>= 0.3.5'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
