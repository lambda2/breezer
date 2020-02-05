require 'minitest/autorun'
require 'breezer'

class TestParser < Minitest::Test
  def test_simple_load
    specs = Breezer::Parser.deps(File.join(File.dirname(__FILE__), './samples/Gemfile.1.lock'))
    assert_equal specs['colorize'][:name], 'colorize'
  end

end
