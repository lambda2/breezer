Gem::Specification.new do |s|
  s.name               = "breezer"
  s.version            = "0.1.0"

  s.authors = ["André Aubin"]
  s.date = '2020-02-05'
  s.description = %q{Automatically set versions in your Gemfile}
  s.email = %q{hello@andral.xyz}
  glob = lambda { |patterns| s.files & Dir[*patterns] }

  s.files = `git ls-files`.split($/)

  s.executables = glob['bin/*'].map { |path| File.basename(path) }
  s.default_executable = s.executables.first if Gem::VERSION < '1.7.'

  s.homepage = %q{http://rubygems.org/gems/breezer}
  s.require_paths = ["lib"]
  s.summary = %q{Breezer!}
  s.license       = 'MIT'

  s.required_ruby_version     = ">= 2.4.0"
  s.required_rubygems_version = ">= 2.7.0"

  s.add_development_dependency "rake", ">= 10.0.0"
  s.add_development_dependency "minitest"
  s.add_development_dependency "minitest-around"
  s.add_development_dependency 'bump'

  s.add_runtime_dependency("bundler", "> 1.0")
end
