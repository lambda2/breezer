require 'bundler'

class Breezer::Parser
  def self.deps(lockfile_path = 'Gemfile.lock', **options)
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(lockfile_path))
    specs = lockfile.specs
    gems_hash = Hash.new.tap do |h|
      specs.each {|s| h[s.name] = {spec: s, dependencies: s.dependencies.map(&:name)}}
    end
    dependencies = gems_hash.keys && gems_hash.values.map { |h| h[:dependencies] }.flatten.uniq.sort
    dependencies.each { |dep| gems_hash.delete(dep) }

    relevant_specs = gems_hash.values.map { |h| [h[:spec].name, h[:spec].version.version] }.to_h

    if options[:debug]
      puts "Mapped dependencies:"
      relevant_specs.each {|name, version| puts "#{name} #{version}"}
    end
    relevant_specs
  end
end
