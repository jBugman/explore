# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'process/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "process-ruby"
  spec.version       = Process::Ruby::VERSION
  spec.authors       = ["Sergey Parshukov"]
  spec.email         = ["sergey.parshukov@me.com"]

  spec.summary       = "It works"
  spec.description   = "It does some stuff"
  spec.homepage      = "https://github.com/jBugman/explore"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
