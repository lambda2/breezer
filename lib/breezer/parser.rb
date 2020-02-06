# frozen_string_literal: true

require 'bundler'

class Breezer::Parser
  def self.deps(lockfile_path = 'Gemfile.lock', **_options)
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(lockfile_path))
    specs = lockfile.specs
    specs.map { |h| [h.name, h.version.version] }.to_h
  end
end
