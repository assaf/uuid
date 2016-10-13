require 'rake/testtask'

spec = Gem::Specification.load(File.expand_path("uuid.gemspec", File.dirname(__FILE__)))

desc "Default Task"
task :default => :test

desc "Run all test cases"
Rake::TestTask.new do |test|
  test.verbose = true
  test.test_files = ['test/*.rb']
  test.warning = true
end

desc "Push new release to rubyforge and git tag"
task :push do
  sh "git push"
  puts "Tagging version #{spec.version} .."
  sh "git tag v#{spec.version}"
  sh "git push --tag"
  puts "Building and pushing gem .."
  sh "gem build #{spec.name}.gemspec"
  sh "gem push #{spec.name}-#{spec.version}.gem"
end

desc "Install #{spec.name} locally"
task :install do
  sh "gem build #{spec.name}.gemspec"
  sh "gem install #{spec.name}-#{spec.version}.gem"
end
