
require 'bundler'

class Breezer::Freezer

  GEM_REGEX = %r{gem[\s]+(?<fullname>['"](?<name>[\w\-_]+)['"])(?<fullversion>,?[\s]?['"](?<version>[~><=]+[\s]?[\d\.]+)['"])?(?<fullsecversion>,?[\s]?['"](?<secversion>[~><=]+[\s]?[\d\.]+)['"])?}
  
  def self.update_gemfile!(gemfile, deps, **options)
    new_gemfile = []
    gemfile.split("\n").each {|line| new_gemfile << parse(line, deps, options) }
    new_gemfile.join("\n")
  end

  def self.parse(line, deps, **options)

    matches = line.match(GEM_REGEX)
    # Drop lines if no gem declared
    return line if (line =~ /gem[\s]+/).nil?

    # Drop line if it's a comment
    return line unless (line =~ /^[\s]?#/).nil?

    matches = line.match(GEM_REGEX)

    # return the line if we didn't matched a name
    return line unless matches[:name]

    good_version = deps[matches[:name]]
    version_string = get_version_string(good_version, options)
    
    # return the line if we didn't find a version
    return line unless (good_version && version_string)

    # if we already have a version and we don't want to override
    return line if matches[:version] && options[:preserve]

    # We remove the other version
    line = line.gsub(matches[:fullsecversion], '') if matches[:fullsecversion]

    # If we had a version
    if matches[:version]
      line.gsub(matches[:version], version_string)
    else
      line.gsub(matches[:fullname], "#{matches[:fullname]}, '#{version_string}'")
    end
  end

  def self.get_version_string(version, options)
    
    options = {level: 'patch'}.merge(options)

    gv = Gem::Version.create(version)
    return unless gv

    segments = [*gv.canonical_segments, 0, 0, 0].first(3)
    case options[:level]
    when "major"
      "~> #{segments.first}"
    when "minor"
      "~> #{segments.first(2).join(".")}"
    when "patch"
      "~> #{segments.first(3).join(".")}"
    when "exact"
      "= #{version}"
    else
      raise("Unsupported option: #{options[:level]}")
    end
  end

end
