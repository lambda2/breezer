# frozen_string_literal: true

require 'minitest/autorun'
require 'breezer'

class TestBreezer < Minitest::Test
  DEPS = {
    'actionpack' => '6.0.2.1',
    'actionview' => '6.0.2.1',
    'activemodel' => '6.0.2.1',
    'activesupport' => '6.0.2.1',
    'ast' => '2.4.0',
    'bindex' => '0.8.1',
    'bootsnap' => '1.4.5',
    'builder' => '3.2.4',
    'bullet' => '6.1.0',
    'byebug' => '11.1.1',
    'colorize' => '0.8.1',
    'concurrent-ruby' => '1.1.5',
    'crass' => '1.0.6',
    'docile' => '1.3.2',
    'erubi' => '1.9.0',
    'ffi' => '1.12.2',
    'i18n' => '1.8.2',
    'jaro_winkler' => '1.5.4',
    'listen' => '3.1.5',
    'loofah' => '2.4.0',
    'method_source' => '0.9.2',
    'mini_portile2' => '2.4.0',
    'minitest' => '5.14.0',
    'msgpack' => '1.3.3',
    'nokogiri' => '1.10.7',
    'parallel' => '1.19.1',
    'parser' => '2.7.0.2',
    'rack' => '2.1.2',
    'rack-test' => '1.1.0',
    'rails-dom-testing' => '2.0.3',
    'rails-html-sanitizer' => '1.3.0',
    'railties' => '6.0.2.1',
    'rainbow' => '3.0.0',
    'rake' => '13.0.1',
    'rb-fsevent' => '0.10.3',
    'rb-inotify' => '0.10.1',
    'rubocop' => '0.79.0',
    'ruby-progressbar' => '1.10.1',
    'ruby_dep' => '1.5.0',
    'simplecov' => '0.18.1',
    'simplecov-html' => '0.11.0',
    'spring' => '2.1.0',
    'spring-watcher-listen' => '2.0.1',
    'thor' => '1.0.1',
    'thread_safe' => '0.3.6',
    'tzinfo' => '1.2.6',
    'unicode-display_width' => '1.6.1',
    'uniform_notifier' => '1.13.0',
    'web-console' => '4.0.1',
    'zeitwerk' => '2.2.2'
  }.freeze

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
        "  gem 'bullet', '~> 6.1.0'"
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
        " gem 'spring', '~> 2.1.0'"
      ],
      [
        "  gem 'spring-watcher-listen', '~> 2.0.0'",
        "  gem 'spring-watcher-listen', '~> 2.0.1'"
      ]
    ].each do |line|
      old_line, new_line = line
      assert_equal new_line, Breezer::Freezer.parse(old_line, DEPS)
    end
  end
end
