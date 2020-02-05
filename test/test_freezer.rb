require 'minitest/autorun'
require 'breezer'

class TestBreezer < Minitest::Test

  DEPS = {
    "bootsnap"=>"1.4.5",
    "bullet"=>"6.1.0",
    "byebug"=>"11.1.1",
    "colorize"=>"0.8.1",
    "rubocop"=>"0.79.0",
    "simplecov"=>"0.18.1",
    "spring-watcher-listen"=>"2.0.1",
    "web-console"=>"4.0.1"
  }

  def test_good_matchs
    [
      [
        "gem 'colorize'",
        "gem 'colorize', '~> 0.8.1'"
      ],
      [
        "gem 'ruby-progressbar'",
        "gem 'ruby-progressbar', '~> 1.10.1'"
      ],
      [
        "gem 'bootsnap', '>= 1.4.2', require: false",
        "gem 'bootsnap', '~> 1.4.5', require: false"
      ],
      [
        "  gem 'bullet'",
        "  gem 'bullet', '~> 6.1.0"
      ],
      [
        "  gem 'byebug', platforms: %i[mri mingw x64_mingw]",
        "  gem 'byebug', '~> 11.1.1', platforms: %i[mri mingw x64_mingw]"
      ],
      [
        "  gem 'rubocop', '~> 0.79.0'",
        "  gem 'rubocop', '~> 0.79.0'"
      ],
      [
        "    gem 'listen', '>= 3.0.5', '< 3.2'",
        "    gem 'listen', '~> 3.1.5'"
      ],
      [
        "  gem 'web-console', '>= 3.3.0'",
        "  gem 'web-console', '~> 4.0.1'"
      ],
      [
        " gem 'spring'",
        " gem 'spring', '~> 2.1.0"
      ],
      [
        "  gem 'spring-watcher-listen', '~> 2.0.0'",
        "  gem 'spring-watcher-listen', '~> 2.0.0'"
      ]
    ].each do |line|
      old_line, new_line = line
      assert_equal new_line, Breezer::Freezer.parse(old_line, DEPS)
    end
  end
      
  # def test_english_hello
  #   assert_equal "hello world",
  #     Breezer.hi("english")
  # end

  # def test_any_hello
  #   assert_equal "hello world",
  #     Breezer.hi("ruby")
  # end

  # def test_spanish_hello
  #   assert_equal "Breezer mundo",
  #     Breezer.hi("spanish")
  # end
end
