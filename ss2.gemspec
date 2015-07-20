# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ss2/version'

Gem::Specification.new do |spec|
  spec.name          = "ss2"
  spec.version       = Ss2::VERSION
  spec.authors       = ["Saravanaselvan"]
  spec.email         = ["spsaravanaselvan@gmail.com"]
  spec.summary       = %q{Connect with shield square bot detection API}
  spec.description   = %q{Connect with shield square bot detection API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable"
  spec.add_dependency "httparty"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
