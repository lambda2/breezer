
require 'bundler'

class Breezer::Freezer

  GEM_REGEX = %r{gem[\s]+(?<fullname>['"](?<name>[\w\-_]+)['"])(?<fullversion>,?[\s]?(?<version>['"][~><=]+[\s]?[\d\.]+['"]))?(?<fullsecversion>,?[\s]?(?<secversion>['"][~><=]+[\s]?[\d\.]+['"]))?}
  
  def self.update_gemfile!(gemfile, deps, **options)
    new_gemfile = []
    gemfile.split("\n").each {|line| new_gemfile << parse(line, deps, options) }
    puts "New gemfile:"
    puts new_gemfile.join("\n")
    new_gemfile.join("\n")
  end

  def self.parse(line, deps, **options)

    puts "  Parsing line: '#{line}'"
    matches = line.match(GEM_REGEX)
    puts "  MATCHES: #{matches.inspect}"
    # Drop lines if no gem declared
    puts "Continue (line =~ /gem[\s]+/) ? => #{(line =~ /gem[\s]+/).inspect}"
    return line if (line =~ /gem[\s]+/).nil?

    # Drop line if it's a comment
    puts "Continue (line =~ /^[\s]?#/) ? => #{(line =~ /^[\s]?#/).inspect}"
    return line unless (line =~ /^[\s]?#/).nil?

    matches = line.match(GEM_REGEX)

    # return the line if we didn't matched a name
    puts "Continue (matches[:name]) ? => #{(matches[:name]).inspect}"
    return line unless matches[:name]

    good_version = deps[matches[:name]]
    version_string = get_version_string(good_version, options)
    
    puts "  Adding version: '#{version_string}'"
    # return the line if we didn't find a version
    puts "Continue (good_version) ? => #{(good_version).inspect}"
    return line unless good_version

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
    segments = [*gv.canonical_segments, 0, 0, 0].first(3)
    case options[:level]
    when "major"
      "~> #{segments.first.join(".")}"
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
