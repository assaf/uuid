# Adapted from the rake Rakefile.

require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'


spec = Gem::Specification.load(File.join(File.dirname(__FILE__), 'uuid.gemspec'))

desc "Default Task"
task 'default' => ['test', 'rdoc']

desc "Run all test cases"
Rake::TestTask.new do |test|
  test.verbose = true
  test.test_files = ['test/*.rb']
  test.warning = true
end

# Create the documentation.
Rake::RDocTask.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
  rdoc.title = "UUID generator"
end


gem = Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

desc "Install the package locally"
task 'install'=>'package' do |task|
  system 'sudo', 'gem', 'install', "pkg/#{spec.name}-#{spec.version}.gem"
end

desc "Uninstall previously installed packaged"
task 'uninstall' do |task|
  system 'sudo', 'gem', 'uninstall', spec.name, '-v', spec.version.to_s
end


task 'release'=>['test', 'package'] do
  
  require 'rubyforge'
=begin  
  header = File.readlines('CHANGELOG').first
  version, date = header.scan(/(\d+\.\d+\.\d+) \((\d{4}-\d{2}-\d{2})\)/).first
  fail "CHANGELOG and spec version numbers do not match: #{version} != #{spec.version}" unless version == spec.version.to_s
  today = Time.now.strftime('%Y-%m-%d')
  fail "CHANGELOG entry not using today's date: #{date} != #{today}" unless date = today

=end
  changes = File.read('CHANGELOG')[/\d+.\d+.\d+.*\n((:?^[^\n]+\n)*)/]
  File.open '.changes', 'w' do |file|
    file.write changes
  end

  puts "Uploading #{spec.name} #{spec.version}"
  files = Dir['pkg/*.{gem,tgz,zip}']
  rubyforge = RubyForge.new
  rubyforge.login    
  rubyforge.userconfig.merge! 'release_changes'=>'.changes', 'preformatted'=>true
  rubyforge.add_release spec.rubyforge_project.downcase, spec.name.downcase, spec.version, *files
  rm_f '.changes'
  puts "Release #{spec.version} uploaded"
end

task 'clobber' do
  rm_f '.changes'
end