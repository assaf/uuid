# Adapted from the rake Rakefile.

require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'


spec = Gem::Specification.load(File.join(File.dirname(__FILE__), 'uuid.gemspec'))

desc "Default Task"
task 'default' => ['test', 'rdoc']


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
  rubyforge.add_release spec.rubyforge_project.downcase, spec.name.downcase, spec.version.to_s, *files
  rm_f '.changes'
  puts "Release #{spec.version} uploaded"
end

task 'clobber' do
  rm_f '.changes'
end
