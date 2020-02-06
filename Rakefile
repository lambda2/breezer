require 'rake/testtask'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/test_*.rb"]
end

desc "Run tests"
task :default => :test
