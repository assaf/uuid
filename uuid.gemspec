spec = Gem::Specification.new do |spec|
  spec.name = 'uuid'
  spec.version = '2.0'
  spec.summary = "UUID generator"
  spec.description = <<-EOF
UUID generator for producing universally unique identifiers based on RFC 4122
(http://www.ietf.org/rfc/rfc4122.txt).
EOF
  spec.authors << 'Assaf Arkin' << 'Eric Hodel'
  spec.email = 'assaf@labnotes.org'
  spec.homepage = 'http://uuid.rubyforge.org/'
  spec.files = Dir['{bin,test,lib,docs}/**/*', 'README.rdoc', 'MIT-LICENSE', 'Rakefile', 'CHANGELOG'].to_a
  spec.require_path = 'lib'
  spec.bindir = 'bin'
  spec.has_rdoc = true
  spec.rdoc_options << '--main' << 'README.rdoc' << '--title' <<  'UUID generator' << '--line-numbers'
  spec.extra_rdoc_files = ['README.rdoc']
  spec.rubyforge_project = 'reliable-msg'

  spec.add_dependency 'macaddr', ['~>1.0']
end
