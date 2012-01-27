require 'rake'
require 'rake/testtask'

require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.verbose = true
  test.test_files = Dir.glob('test/openssl/**/test_*.rb')
end
