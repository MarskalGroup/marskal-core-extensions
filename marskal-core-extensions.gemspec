# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marskal/core/extensions/version'

Gem::Specification.new do |spec|
  spec.name          = "marskal-core-extensions"
  spec.version       = Marskal::Core::Extensions::VERSION
  spec.authors       = ["Mike Urban"]
  spec.email         = ["mike@marskalgroup.com"]
  spec.summary       = %q{Many handy uitilities to extend Ruby on Rails core functionality}
  spec.description   = %q{Extends modules/classes such as Array, String, Numeric, Date, I18n, File and more}
  spec.homepage      = "http://www.marskalgroup.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  # spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 0"
end
