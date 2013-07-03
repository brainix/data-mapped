# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_mapped/version'

Gem::Specification.new do |spec|
  spec.name          = "data_mapped"
  spec.version       = DataMapped::VERSION
  spec.authors       = ["Rajiv Bakulesh Shah"]
  spec.email         = ["brainix@gmail.com"]
  spec.description   = %q{Mixins for DataMapper}
  spec.summary       = %q{Mixins for DataMapper}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "data_mapper"
  spec.add_dependency "activesupport"
  spec.add_dependency "sunspot", "~> 1.3.3"
  spec.add_dependency "sunspot_rails", "~> 1.3.3"
  spec.add_development_dependency "sunspot_solr", "~> 1.3.3"
end
