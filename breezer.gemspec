# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'breezer/version'

Gem::Specification.new do |s|
  s.name = 'breezer'
  s.version = Breezer::VERSION

  s.authors = ['André Aubin']
  s.date = '2020-02-05'
  s.description = 'Automatically set versions in your Gemfile'
  s.email = 'hello@andral.xyz'

  glob = ->(patterns) { s.files & Dir[*patterns] }

  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)

  s.executables = glob['bin/*'].map { |path| File.basename(path) }
  s.default_executable = s.executables.first if Gem::VERSION < '1.7.'

  s.homepage = 'http://rubygems.org/gems/breezer'
  s.require_paths = ['lib']
  s.summary = 'Breezer!'
  s.license = 'MIT'

  s.required_ruby_version     = '>= 2.1.0'
  s.required_rubygems_version = '>= 2.7.0'

  s.add_development_dependency 'bump', '~> 0.8'
  s.add_development_dependency 'minitest', '~> 5.14'
  s.add_development_dependency 'minitest-around', '~> 0.5'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 0.79.0'

  s.add_runtime_dependency('bundler', '> 1.0')
end
