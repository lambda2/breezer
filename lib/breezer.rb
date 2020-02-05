class Breezer
  def self.freeze!(gemfile_path, lockfile_path, **options)
    absolute_lockfile_path = File.join(lockfile_path)
    absolute_gemfile_path = File.join(gemfile_path)
    ENV['BUNDLE_GEMFILE'] = absolute_gemfile_path

    deps = Parser.deps(absolute_lockfile_path, options)

    gemfile = Bundler.read_file(absolute_gemfile_path)
    updated_gemfile = Freezer.update_gemfile!(gemfile, deps, options)
    
    puts updated_gemfile
    if options[:dry]
      puts updated_gemfile
    else
      File.open(options[:output] || absolute_gemfile_path, 'w') do |file|
        puts file.inspect
        file.write(updated_gemfile)
      end
    end
    updated_gemfile
  end
end

require 'breezer/parser'
require 'breezer/freezer'
