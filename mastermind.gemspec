lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mastermind/version'

Gem::Specification.new do |gem|
  gem.name          = "mastermind"
  gem.platform      = Gem::Platform::RUBY
  gem.version       = Mastermind::VERSION
  gem.authors       = ["Dan Ryan"]
  gem.email         = ["dan@appliedawesome.com"]
  gem.description   = %q{Infrastructure orchestration engine}
  gem.summary       = %q{Mastermind is an infrastructure orchestration engine. Its purpose is to provide the ability to compose and automate complex tasks with predefined and reproducible outcomes.}
  gem.homepage      = "https://github.com/danryan/mastermind"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'activesupport', '~> 3.2.8'
  # gem.add_dependency 'json', '~> 1.7.5'
  gem.add_dependency 'active_attr', '~> 0.6.0'
  # gem.add_dependency 'state_machine'
  gem.add_dependency 'ruote', '~> 2.3.0'
  gem.add_dependency 'ruote-redis', '~> 2.3.0'
  gem.add_dependency 'cabin', '~> 0.4.4'
  gem.add_dependency 'fog', '~> 1.5.0'
  gem.add_dependency 'tinder', '~> 1.9.1'
  gem.add_dependency 'net-ssh', '~> 2.5.2'
  gem.add_dependency 'net-ssh-multi', '~> 1.1'
  gem.add_dependency 'spice', '~> 1.0.4'
  gem.add_dependency 'faraday', '~> 0.8.4'
  gem.add_dependency 'addressable', '~> 2.3.2'
end