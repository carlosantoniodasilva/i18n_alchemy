require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

desc 'Default: run unit tests.'
task default: :test

desc 'Run tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = true
end
