# frozen_string_literal: true

require_relative 'lib/heroku-deflater/version'

Gem::Specification.new do |s|
  s.name = 'heroku-deflater'
  s.version = HerokuDeflater::VERSION
  s.authors = ['Roman Shterenzon']
  s.email = 'romanbsd@yahoo.com'

  s.summary = 'Deflate assets on heroku'
  s.description = 'Deflate assets on Heroku'
  s.homepage = 'https://github.com/romanbsd/heroku-deflater'
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  s.require_paths = ['lib']
  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.licenses = ['MIT']
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
end
