require 'bundler'

class Breezer::Parser
  def self.deps(lockfile_path = 'Gemfile.lock', **options)
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(lockfile_path))
    specs = lockfile.specs
    relevant_specs = specs.map { |h| [h.name, h.version.version] }.to_h
    if options[:debug]
      puts "Mapped dependencies:"
      relevant_specs.each {|name, version| puts "#{name} #{version}"}
    end
    relevant_specs
  end
end
