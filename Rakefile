require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake/clean'

desc 'Run all tests available'
task :test do
  Dir.glob('./test/**/*_test.rb') { |file| require file }
end

task default: :test
