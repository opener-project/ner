require File.expand_path('../lib/opener/ner/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'opener-ner'
  gem.version     = Opener::Ner::VERSION
  gem.authors     = ['development@olery.com']
  gem.summary     = 'Primary NER component that wraps the various NER kernels.'
  gem.description = gem.summary
  gem.has_rdoc    = 'yard'

  gem.required_ruby_version = '>= 1.9.2'

  gem.files       = `git ls-files`.split("\n").sort
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'sinatra', '~> 1.4'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'opener-ner-base'
  gem.add_dependency 'opener-ner-fr'
  gem.add_dependency 'opener-webservice'

  gem.add_development_dependency 'rake'
end
