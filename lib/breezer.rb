class Breezer
  def self.freeze!(gemfile_path, lockfile_path, **options)
    absolute_lockfile_path = File.join(File.dirname(__FILE__), '..', lockfile_path)
    absolute_gemfile_path = File.join(File.dirname(__FILE__), '..', gemfile_path)
    ENV['BUNDLE_GEMFILE'] = absolute_gemfile_path
    
    puts "absolute_lockfile_path: #{absolute_lockfile_path}"
    puts "absolute_gemfile_path: #{absolute_gemfile_path}"
    
    deps = Parser.deps(absolute_lockfile_path, options)

    gemfile = Bundler.read_file(absolute_gemfile_path)
    updated_gemfile = Freezer.update_gemfile!(gemfile, deps, options)
    
    File.write(absolute_gemfile_path, updated_gemfile)
  end
end

require 'breezer/parser'
require 'breezer/freezer'
