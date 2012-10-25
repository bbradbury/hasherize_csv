# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hasherize_csv/version'

Gem::Specification.new do |gem|
  gem.name          = "hasherize_csv"
  gem.version       = HasherizeCsv::VERSION
  gem.authors       = ["Brent Bradbury"]
  gem.email         = ["brent@brentium.com"]
  gem.description   = %q{Turns csv files into hashes without reading the entire csv into memory}
  gem.summary       = %q{Hasherizes a csv file line by line}
  gem.homepage      = "https://github.com/bbradbury/hasherize_csv"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies
  # specify any dependencies here; for example:
  # gem.add_runtime_dependency "activesupport", ">=3.0.0"
  # gem.add_runtime_dependency "testunit"
end
