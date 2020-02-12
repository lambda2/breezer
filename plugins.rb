# frozen_string_literal: true

require 'bundler'
require 'breezer'

# This is the plugin for bundler
class Breezer < Bundler::Plugin::API
  command 'breeze'

  def exec(_command, args)
    r = Breezer::Command.run!(args)
    exit(r == false ? 2 : 0)
  end
end
