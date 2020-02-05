require 'test/unit'
require 'breezer'

class BreezerTest < Test::Unit::TestCase
  def test_english_hello
    assert_equal "hello world", Breezer.hi("english")
  end

  def test_any_hello
    assert_equal "hello world", Breezer.hi("ruby")
  end

  def test_spanish_hello
    assert_equal "breezer mundo", Breezer.hi("spanish")
  end
end
