# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'captureful_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = "captureful_formatter"
  spec.version       = CapturefulFormatter::VERSION
  spec.authors       = ["Atsushi Yasuda"]
  spec.email         = ["atsushi.yasuda.jp@gmail.com"]
  spec.summary       = %q(Yet another RSpec custom formatter for Turnip)
  spec.description   = %q(Yet another RSpec custom formatter for Turnip. Take screenshots step by step.)
  spec.homepage      = "https://github.com/crowdworks/captureful_formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'capybara', "~> 2.2"
  spec.add_dependency 'rspec', '>=3.0.0'
  spec.add_dependency 'turnip', '~> 1.2.2'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
