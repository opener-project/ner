require File.expand_path('../lib/opener/ner/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'opener-ner'
  gem.version     = Opener::Ner::VERSION
  gem.authors     = ['development@olery.com']
  gem.summary     = 'Primary NER component that wraps the various NER kernels.'
  gem.description = gem.summary
  gem.has_rdoc    = 'yard'
  gem.license     = 'Apache 2.0'

  gem.required_ruby_version = '>= 1.9.2'

  gem.files = Dir.glob([
    'lib/**/*',
    'config.ru',
    '*.gemspec',
    'README.md',
    'LICENSE.txt',
    'exec/**/*'
  ]).select { |file| File.file?(file) }

  gem.executables = Dir.glob('bin/*').map { |file| File.basename(file) }

  gem.add_dependency 'sinatra', '~> 1.4'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'puma'
  gem.add_dependency 'opener-daemons'
  gem.add_dependency 'opener-ner-base', ['~> 2.0', '>= 2.0.1']
  gem.add_dependency 'opener-webservice'
  gem.add_dependency 'opener-core', '~> 1.0'

  gem.add_development_dependency 'rake'
end
