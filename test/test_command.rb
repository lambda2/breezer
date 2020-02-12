# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/around/spec'
require 'breezer'

describe Breezer::Command do # rubocop:todo Metrics/BlockLength
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

  it 'can get_gemfile_file' do
    _(Breezer::Command.get_gemfile_file([])).must_equal('./Gemfile')
    _(Breezer::Command.get_gemfile_file(['..'])).must_equal('../Gemfile')
    _(Breezer::Command.get_gemfile_file(['Gemfile'])).must_equal('Gemfile')
    _(Breezer::Command.get_gemfile_file(['./Gemfile.checked'])).must_equal('./Gemfile.checked')
    _(Breezer::Command.get_gemfile_file(['../../idontexist'])).must_equal('../../idontexist')
  end

  it 'can parse_options' do
    _(Breezer::Command.parse_options({}, [])).must_equal({})
    _(Breezer::Command.parse_options({}, %w[-l major])).must_equal(level: 'major')
    _(Breezer::Command.parse_options({}, %w[-L Gemfile.look])).must_equal(lockfile_file: 'Gemfile.look')
    _(Breezer::Command.parse_options({}, %w[-d])).must_equal(dry: true)
    _(Breezer::Command.parse_options({}, %w[-o Gemfool])).must_equal(output: 'Gemfool')
    _(Breezer::Command.parse_options({}, %w[-c])).must_equal(check: true)
  end

  it 'run without options' do
    _specs = Breezer::Command.run!(%w[])
    _(File.read('Gemfile')).must_equal File.read('Gemfile.final.patch')
  end

  it 'run with minor level options' do
    _specs = Breezer::Command.run!(%w[Gemfile -l minor])
    _(File.read('Gemfile')).must_equal File.read('Gemfile.final.minor')
  end

  it 'run with dry run' do
    specs = Breezer::Command.run!(%w[Gemfile -d])
    _(specs).must_equal File.read('Gemfile.final.patch')
    _(File.read('Gemfile')).wont_be_same_as File.read('Gemfile.final.patch')
  end

  it 'run with custom output' do
    specs = Breezer::Command.run!(%w[Gemfile -o Gemfile.custom])

    _(specs).must_equal File.read('Gemfile.final.patch')
    _(File.read('Gemfile')).wont_be_same_as File.read('Gemfile.final.patch')
    _(File.read('Gemfile.custom')).must_equal File.read('Gemfile.final.patch')
  end

  it 'run with checks on invalid gemfile' do
    specs = Breezer::Command.run!(%w[Gemfile -c])
    _(specs).must_equal false
    _(File.read('Gemfile')).wont_be_same_as File.read('Gemfile.final.patch')
  end

  it 'run with checks on valid gemfile' do
    specs = Breezer::Command.run!(%w[Gemfile.checked --lockfile=Gemfile.lock -c])
    _(specs).must_equal true
  end
end
