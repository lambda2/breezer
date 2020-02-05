require 'minitest/autorun'
require 'breezer'

class TestParser < Minitest::Test
  def test_simple_load
    Bundler::SharedHelpers.chdir("#{File.dirname(__FILE__)}/samples") do
      specs = Breezer::Parser.deps('Gemfile.lock')
      assert_equal specs['colorize'], '0.8.1'
    end
  end

end
