# Adapted from the rake Rakefile.

require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rubygems/source_info_cache'


spec = Gem::Specification.load(File.join(File.dirname(__FILE__), 'uuid.gemspec'))

desc "Default Task"
task 'default' => ['test', 'rdoc']


desc "If you're building from sources, run this task first to setup the necessary dependencies"
task 'setup' do
  windows = Config::CONFIG['host_os'] =~ /windows|cygwin|bccwin|cygwin|djgpp|mingw|mswin|wince/i
  rb_bin = File.expand_path(Config::CONFIG['ruby_install_name'], Config::CONFIG['bindir'])
  spec.dependencies.select { |dep| Gem::SourceIndex.from_installed_gems.search(dep).empty? }.each do |missing|
    dep = Gem::Dependency.new(missing.name, missing.version_requirements)
    spec = Gem::SourceInfoCache.search(dep, true, true).last
    fail "#{dep} not found in local or remote repository!" unless spec
    puts "Installing #{spec.full_name} ..."
    args = [rb_bin, '-S', 'gem', 'install', spec.name, '-v', spec.version.to_s]
    args.unshift('sudo') unless windows || ENV['GEM_HOME']
    sh args.map{ |a| a.inspect }.join(' ')
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
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
  rdoc.title = "UUID generator"
end


gem = Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

desc "Install the package locally"
task 'install'=>['setup', 'package'] do |task|
  rb_bin = File.expand_path(Config::CONFIG['ruby_install_name'], Config::CONFIG['bindir'])
  args = [rb_bin, '-S', 'gem', 'install', "pkg/#{spec.name}-#{spec.version}.gem"]
  windows = Config::CONFIG['host_os'] =~ /windows|cygwin|bccwin|cygwin|djgpp|mingw|mswin|wince/i
  args.unshift('sudo') unless windows || ENV['GEM_HOME']
  sh args.map{ |a| a.inspect }.join(' ')
end

desc "Uninstall previously installed packaged"
task 'uninstall' do |task|
  rb_bin = File.expand_path(Config::CONFIG['ruby_install_name'], Config::CONFIG['bindir'])
  args = [rb_bin, '-S', 'gem', 'install', spec.name, '-v', spec.version.to_s]
  windows = Config::CONFIG['host_os'] =~ /windows|cygwin|bccwin|cygwin|djgpp|mingw|mswin|wince/i
  args.unshift('sudo') unless windows || ENV['GEM_HOME']
  sh args.map{ |a| a.inspect }.join(' ')
end


task 'release'=>['setup', 'test', 'package'] do
  
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
  rubyforge.configure
  rubyforge.login    
  rubyforge.userconfig.merge! 'release_changes'=>'.changes', 'preformatted'=>true
  rubyforge.add_release spec.rubyforge_project.downcase, spec.name.downcase, spec.version, *files
  rm_f '.changes'
  puts "Release #{spec.version} uploaded"
end

task 'clobber' do
  rm_f '.changes'
end
