# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "heroku-deflater"
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Shterenzon"]
  s.date = "2013-11-07"
  s.description = "Deflate assets on heroku"
  s.email = "romanbsd@yahoo.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "heroku-deflater.gemspec",
    "lib/heroku-deflater.rb",
    "lib/heroku-deflater/railtie.rb",
    "lib/heroku-deflater/serve_zipped_assets.rb",
    "lib/heroku-deflater/skip_binary.rb",
    "spec/fixtures/assets/spec.js",
    "spec/fixtures/assets/spec.js.gz",
    "spec/fixtures/assets/spec2.js",
    "spec/fixtures/non-assets/spec.js.gz",
    "spec/serve_zipped_assets_spec.rb",
    "spec/skip_binary_spec.rb"
  ]
  s.homepage = "http://github.com/romanbsd/heroku-deflater"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Deflate assets on heroku"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.4.5"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 1.4.5"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.4.5"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

