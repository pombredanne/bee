# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bee/version'

Gem::Specification.new do |spec|
  spec.name          = "bee"
  spec.version       = Bee::VERSION
  spec.authors       = ["Shane McIntosh"]
  spec.email         = ["shanemcintosh@acm.org"]

  spec.summary       = %q{Build Execution Explorer (BEE).}
  spec.description   = %q{BEE is a tool for loading data produced during a build into a graph environment that supports exploration.}
  spec.homepage      = "http://shanemcintosh.org/"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  # Need neo4j
  spec.add_development_dependency "neo4j", "> 5.0.0"
  spec.add_development_dependency "neo4j-community"
  spec.add_development_dependency "neo4j-rake_tasks"
end
