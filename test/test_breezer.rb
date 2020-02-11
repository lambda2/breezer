# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/around/spec'
require 'breezer'

describe Breezer do # rubocop:todo Metrics/BlockLength
  around do |test|
    files = Dir["#{File.dirname(__FILE__)}/samples/*"]
    Dir.mktmpdir do |dir|
      @dir = dir
      FileUtils.cp files, dir
      Bundler::SharedHelpers.chdir(dir) do
        test.call
      end
    end
  end

  it 'run without options' do
    _specs = Breezer.freeze!('Gemfile', 'Gemfile.lock', {})
    _(File.read('Gemfile')).must_equal File.read('Gemfile.final.patch')
  end

  it 'run with minor level options' do
    _specs = Breezer.freeze!('Gemfile', 'Gemfile.lock', level: :minor)
    _(File.read('Gemfile')).must_equal File.read('Gemfile.final.minor')
  end

  it 'run with dry run' do
    specs = Breezer.freeze!('Gemfile', 'Gemfile.lock', dry: true)
    _(specs).must_equal File.read('Gemfile.final.patch')
    _(File.read('Gemfile')).wont_be_same_as File.read('Gemfile.final.patch')
  end

  it 'run with custom output' do
    specs = Breezer.freeze!('Gemfile', 'Gemfile.lock', output: 'Gemfile.custom')
    _(specs).must_equal File.read('Gemfile.final.patch')
    _(File.read('Gemfile')).wont_be_same_as File.read('Gemfile.final.patch')
    _(File.read('Gemfile.custom')).must_equal File.read('Gemfile.final.patch')
  end

  it 'run with checks on invalid gemfile' do
    specs = Breezer.freeze!('Gemfile', 'Gemfile.lock', check: true)
    _(specs).must_equal false
    _(File.read('Gemfile')).wont_be_same_as File.read('Gemfile.final.patch')
  end

  it 'run with checks on valid gemfile' do
    specs = Breezer.freeze!('Gemfile.checked', 'Gemfile.lock', check: true)
    _(specs).must_equal true
  end
end
