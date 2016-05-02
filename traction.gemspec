# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traction/version'

Gem::Specification.new do |spec|
  spec.name          = "traction"
  spec.version       = Traction::VERSION
  spec.date          = Traction::DATE

  spec.summary       = "A Ruby wrapper of the Traction Digital API"
  spec.description   = "A Ruby wrapper of the Traction Digital API. The wrapper contains only methods for endpoints for which previous access has been established. The addition of new methods when an API is created is encouraged."

  spec.authors       = ["Philip Castiglione", "Andrew Buntine"]
  spec.email         = ["philipcastiglione@gmail.com", "dev@hhd.com.au"]
  spec.homepage      = "https://github.com/hardhatdigital/traction"

  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
