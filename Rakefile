require 'rake/testtask'
require 'rake/rdoctask'


spec = Gem::Specification.load(File.expand_path("uuid.gemspec", File.dirname(__FILE__)))

desc "Default Task"
task :default => :test


desc "If you're building from sources, run this task first to setup the necessary dependencies"
task 'setup' do
  missing = spec.dependencies.select { |dep| Gem::SourceIndex.from_installed_gems.search(dep).empty? }
  missing.each do |dep|
    if Gem::SourceIndex.from_installed_gems.search(dep).empty?
      puts "Installing #{dep.name} ..."
      rb_bin = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
      args = []
      args << rb_bin << '-S' << 'gem' << 'install' << dep.name
      args << '--version' << dep.version_requirements.to_s
      args << '--source' << 'http://gems.rubyforge.org'
      args << '--install-dir' << ENV['GEM_HOME'] if ENV['GEM_HOME']
      sh *args
    end
  end
end


desc "Run all test cases"
Rake::TestTask.new do |test|
  test.verbose = true
  test.test_files = ['test/*.rb']
  test.warning = true
end

# Create the documentation.
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include "README.rdoc", "lib/**/*.rb"
  rdoc.options = spec.rdoc_options
end



desc "Push new release to gemcutter and git tag"
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
  sudo = "sudo" unless File.writable?( Gem::ConfigMap[:bindir])
  sh "#{sudo} gem install #{spec.name}-#{spec.version}.gem"
end
