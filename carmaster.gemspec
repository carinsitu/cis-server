lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carmaster/version'

Gem::Specification.new do |spec|
  spec.name          = 'carmaster'
  spec.version       = Carmaster::VERSION
  spec.authors       = ['Romuald Conty']
  spec.email         = ['romuald@opus-codium.fr']

  spec.summary       = 'Racing server'
  spec.description   = 'One to control all of them'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ruby-sdl2', '~> 0.3.4'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.67'
end
