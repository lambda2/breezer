class Breezer

  def self.freeze!(gemfile_path, lockfile_path, **options)
    absolute_lockfile_path = File.join(lockfile_path)
    absolute_gemfile_path = File.join(gemfile_path)
    ENV['BUNDLE_GEMFILE'] = absolute_gemfile_path

    deps = Parser.deps(absolute_lockfile_path, options)

    gemfile = Bundler.read_file(absolute_gemfile_path)
    if options[:check]
      checks = Freezer.check_gemfile!(gemfile, deps, options)
      print_check_results(checks)
      return checks.values.map{|e| e[:valid]}.all?
    else
      updated_gemfile = Freezer.update_gemfile!(gemfile, deps, options)
      write_or_print_output(updated_gemfile, options[:output] || absolute_gemfile_path, options)
    end
  end

  private

  def self.write_or_print_output(updated_gemfile, output_path, **options)
    if options[:dry]
      puts updated_gemfile
    else
      File.open(output_path, 'w') do |file|
        file.write(updated_gemfile)
      end
    end
    updated_gemfile
  end

  def self.print_check_results(checks)
    invalid = checks.reject{|_k, v| v[:valid]}
    (puts "Gemfile dependencies are properly constrained" && return) if invalid.empty?
    puts "#{invalid.values.count} dependencies are not properly set"
    invalid.each do |no, line|
      suggested = line[:proposed_version] ? " (Suggested: '~> #{line[:proposed_version]}')" : ''
      puts ("Line %-3d: gem %-20s%s" % [no, "'#{line[:name]}'", suggested])
    end
  end
end

require 'breezer/parser'
require 'breezer/freezer'
