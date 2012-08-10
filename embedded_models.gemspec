# -*- encoding: utf-8 -*-
require File.expand_path('../lib/embedded_models/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mitch Crowe"]
  gem.email         = ["crowe.mitch@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/mcrowe/embedded_models"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "embedded_models"
  gem.require_paths = ["lib"]
  gem.version       = EmbeddedModels::VERSION

  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.8'
  gem.add_development_dependency 'sqlite3', '~> 1.3'
  gem.add_development_dependency 'activerecord', '~> 3.0'
  gem.add_development_dependency 'with_model', '~> 0.2'
end
