# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lou/version'

Gem::Specification.new do |spec|
  spec.name          = "lou"
  spec.version       = Lou::VERSION
  spec.authors       = ["Matthew Thorley"]
  spec.email         = ["padwasabimasala on gmail"]
  spec.description   = "convert request params into an activerecord arel query"
  spec.summary       = "convert request params into an activerecord arel query"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_dependency "activerecord", "~> 4.0.0"
end
