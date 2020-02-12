# This is the plugin for bundler
class Breezer < Bundler::Plugin::API
  # Register this class as a handler for the `my_command` command
  command "freeze"

  # The exec method will be called with the `command` and the `args`.
  # This is where you should handle all logic and functionality
  def exec(command, args)
    puts "You called " + command + " with args: " + args.inspect
  end
end

# #!/usr/bin/env ruby
# # frozen_string_literal: true

# require 'bundler'
# require 'breezer'

# r = Breezer::Command.run!(ARGV)
# exit(r == false ? 2 : 0)
