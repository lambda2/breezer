require 'minitest/autorun'
require 'breezer'

class TestParser < Minitest::Test
  def test_simple_load
    Bundler::SharedHelpers.chdir("#{File.dirname(__FILE__)}/samples") do
      specs = Breezer::Parser.deps('Gemfile.lock')
      puts specs['colorize'].inspect
      assert_equal specs['colorize'].name, 'colorize'
    end
  end

end
