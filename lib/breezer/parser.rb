require 'bundler'

class Breezer::Parser
  def self.deps(lockfile_path = 'Gemfile.lock', **options)
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(lockfile_path))
    gems_hash = Hash.new.tap do |h|
      specs.each {|s| h[s.name] = {spec: s, dependencies: s.dependencies.map(&:name)}}
    end
    dependencies = gems_hash.keys && gems_hash.values.map { |h| h[:dependencies] }.flatten.uniq.sort
    dependencies.each { |dep| gems_hash.delete(dep) }

    relevant_specs = gems_hash.values.map { |h| h[:spec] }

    if options[:debug]
      puts "Mapped dependencies:"
      relevant_specs.each {|e| puts "#{e.name} #{e.version}"}
    end
  end
end
