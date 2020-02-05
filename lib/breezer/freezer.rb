
require 'bundler'

class Breezer::Freezer

  GEM_REGEX = /gem[\s\t]+(?<name>['"][\w\-_]+['"])(?<fullversion>,?[\s\t]?(?<version>['"][~><=]+[\s\t]?[\d\.]+['"]))?(?<fullsecversion>,?[\s\t]?(?<secversion>['"][~><=]+[\s\t]?[\d\.]+['"]))?/
  def self.update_gemfile!(gemfile, deps, **options)
    new_gemfile = []
    gemfile.split("\n").each {|line| new_gemfile << parse(line, deps, options) }
    puts "New gemfile:"
    puts new_gemfile.join("\n")
    new_gemfile.join("\n")
  end

  def self.parse(line, deps, **options)
    # Drop lines if no gem declared
    return line unless line =~ /gem[\s\t]+/

    # Drop line if it's a comment
    return line unless line =~ /^[\s\t]?#/

    matches = line.match(GEM_REGEX)

    # return the line if we didn't matched a name
    return line unless matches[:name]

    good_version = deps[matches[:name]]
    version_string = get_version_string()
    
    # return the line if we didn't find a version
    return line unless good_version

    # if we already have a version and we don't want to override
    return line if matches[:version] && options[:preserve]

    # We remove the other version
    line = line.gsub(matches[:fullsecversion], '') if matches[:fullsecversion]

    line.gsub(matches[:version], version_string)
  end

  def self.get_version_string(version, options)
    gv = Gem::Version.create(version)
    segments = [*gv.canonical_segments, 0, 0, 0].first(3)
    case options[:level]
    when "major"
      "~> #{gv.first.join(".")}"
    when "minor"
      "~> #{gv.first(2).join(".")}"
    when "patch"
      "~> #{gv.first(3).join(".")}"
    when "exact"
      "= #{version}"
    else
      raise("Unsupported option: #{options[:level]}")
    end
  end

end
