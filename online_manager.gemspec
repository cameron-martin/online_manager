# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'online_manager'
  spec.version       = '0.0.1'
  spec.authors       = ['Cameron Martin']
  spec.email         = ['cameronmartin123@gmail.com']
  spec.summary       = %q{Manage user's online status.}
  spec.description   = %q{Manage whether users are online when you have a regular heartbeat, coming from a websocket for example.}
  spec.homepage      = 'https://github.com/cameron-martin/online_manager'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'eventmachine', '~> 1.0'
end
