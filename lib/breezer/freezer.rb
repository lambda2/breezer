# frozen_string_literal: true

require 'bundler'

class Breezer::Freezer
  GEM_REGEX = /gem[\s]+(?<fullname>['"](?<name>[\w\-_]+)['"])(?<fullversion>,?[\s]?['"](?<version>[~><=]+[\s]?[\d\.]+)['"])?(?<fullsecversion>,?[\s]?['"](?<secversion>[~><=]+[\s]?[\d\.]+)['"])?/.freeze

  def self.update_gemfile!(gemfile, deps, **options)
    new_gemfile = []
    gemfile.split("\n").each { |line| new_gemfile << parse(line, deps, options) }
    [*new_gemfile, ''].join("\n")
  end

  def self.check_gemfile!(gemfile, deps, **options)
    gemfile.split("\n").each_with_index.map do |line, no|
      [no + 1, check(line, deps, options)]
    end.to_h
  end

  # Parse a gemfile line, and return the line updated with dependencies
  def self.parse(line, deps, **options)
    return line unless valid_line?(line)

    matches = line.match(GEM_REGEX)

    # return the line if we didn't matched a name
    return line unless matches[:name]

    proposed_version = deps[matches[:name]]
    version_string = version_for_name(proposed_version, options)

    # return the line if we didn't find a version
    return line unless proposed_version && version_string

    # if we already have a version and we don't want to override
    return line if matches[:version] && options[:preserve]

    transform_line_for_version(line, matches, version_string)
  end

  # Return false if there is no deps declaration in the given line
  def self.valid_line?(line)
    # Drop lines if no gem declared
    return false if (line =~ /gem[\s]+/).nil?

    # Skip git and github direct references
    return false if line =~ %r{(git://|(github(:|\s)))}

    # Drop line if it's a comment
    return false unless (line =~ /^[\s]?#/).nil?

    # Drop line if it contains a skip comment
    return false unless (line =~ /breezer-disable/).nil?

    true
  end

  # Parse a gemfile line, and return true or false wether the line is valid
  def self.check(line, deps, **options)
    return { valid: true } unless valid_line?(line)

    matches = line.match(GEM_REGEX)

    # return the line if we didn't matched a name
    return { valid: true } unless matches[:name]

    proposed_version = deps[matches[:name]]
    version_for_name(proposed_version, options)

    # Do we have a version ?
    {
      name: matches[:name],
      proposed_version: proposed_version,
      valid: !matches[:version].nil?
    }
  end

  # Will rewrite the old deps line with the good version
  def self.transform_line_for_version(line, matches, version_string)
    # We remove the other version
    line = line.gsub(matches[:fullsecversion], '') if matches[:fullsecversion]

    # If we had a version
    if matches[:version]
      line.gsub(matches[:version], version_string)
    else
      line.gsub(matches[:fullname], "#{matches[:fullname]}, '#{version_string}'")
    end
  end

  # Will return the Gemfile.lock version of a deps
  def self.version_for_name(proposed_version, options)
    get_version_string(proposed_version, options)
  end

  # Will convert the version according to the given level (default 'patch')
  def self.get_version_string(version, options)
    options = { level: 'patch' }.merge(options)

    gv = Gem::Version.create(version)
    return unless gv

    segments = [*gv.canonical_segments, 0, 0, 0].first(3)
    case options[:level].to_s
    when 'major'
      "~> #{segments.first}"
    when 'minor'
      "~> #{segments.first(2).join('.')}"
    when 'patch'
      "~> #{segments.first(3).join('.')}"
    when 'exact'
      "= #{version}"
    else
      raise("Unsupported option: #{options[:level]}")
    end
  end
end
