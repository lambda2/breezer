class Breezer
  def self.freeze!(gemfile_path, lockfile_path, **options)
    deps = Parser.deps(lockfile_path, options)
  end
end

require 'breezer/parser'
