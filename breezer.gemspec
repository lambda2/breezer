Gem::Specification.new do |s|
  s.name               = "breezer"
  s.version            = "0.0.1"

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
  s.summary = %q{BunFreezer!}

end

