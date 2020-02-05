class Breezer
  def self.freeze!(gemfile_path, lockfile_path, **options)
    absolute_lockfile_path = File.join(File.dirname(__FILE__), '..', lockfile_path)
    absolute_gemfile_path = File.join(File.dirname(__FILE__), '..', gemfile_path)
    ENV['BUNDLE_GEMFILE'] = absolute_gemfile_path
    puts "absolute_lockfile_path: #{absolute_lockfile_path}"
    puts "absolute_gemfile_path: #{absolute_gemfile_path}"
    puts ENV
    # deps = Parser.deps(absolute_lockfile_path, options)
  end
end

require 'breezer/parser'
