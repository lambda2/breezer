# frozen_string_literal: true

require 'optparse'

module Breezer

  #
  # Used to parse the command line args and run the breezer accordingly
  #
  class Command
    class << self
      def run!(args)
        gemfile_file = get_gemfile_file(args)

        options = parse_options({ debug: false }, args)
        lockfile_file = options[:lockfile_file] || "#{gemfile_file}.lock"

        unless File.file?(gemfile_file)
          puts "Unable to find a Gemfile (searched in #{gemfile_file})"
          raise NoGemfileException, "Unable to find a Gemfile (searched in #{gemfile_file})"
        end

        unless File.file?(lockfile_file)
          puts "Unable to find a Lockfile (Gemfile.lock). If you don't have a Gemfile.lock yet, "\
              "you can run 'bundle install' first. (searched in #{lockfile_file})"
          raise NoLockfileException, "Unable to find a Lockfile (Gemfile.lock) (searched in #{lockfile_file})"
        end

        Breezer.freeze!(gemfile_file, lockfile_file, options)
      end

      def get_gemfile_file(args)
        gemfile_dir = args.first || '.'

        File.directory?(gemfile_dir) ? File.join(gemfile_dir, 'Gemfile') : gemfile_dir
      end

      def parse_options(options = { debug: false }, argv) # rubocop:todo Metrics/AbcSize
        OptionParser.new do |parser| # rubocop:todo Metrics/BlockLength
          parser.banner = 'Usage: breezer DIR [options]'

          parser.on('-l', '--level LEVEL', 'Set the minimum level of gem updates (default: patch).'\
                                          ' Set to "exact" to lock gems versions (not recommended).') do |v|
            unless %w[major minor patch exact].include?(v)
              raise InvalidLevelException, "Error: level must be one of: 'major', 'minor', 'patch' or 'exact', #{v} given."
            end

            options[:level] = v
          end

          parser.on('-L', '--lockfile NAME', 'Use different lockfile (default: Gemfile.lock)') do |v|
            options[:lockfile_file] = v
          end

          parser.on('-d', '--dry-run', 'Print the updated Gemfile instead of writing it') do
            options[:dry] = true
          end

          parser.on('-o', '--output FILE', 'The output file (default: Gemfile)') do |v|
            options[:output] = v
          end

          parser.on('-c', '--check', 'Check that all gems have version constraints') do |_v|
            options[:check] = true
          end

          parser.on('-h', '--help', 'Show this help message') do
            puts parser
            exit(0)
          end

          parser.on('-v', '--version', 'Show version') do
            puts Breezer::VERSION
            exit(0)
          end
        end.parse!(argv)
      end
    end
  end
end
