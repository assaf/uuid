spec = Gem::Specification.new do |spec|
  spec.name = 'uuid'
  spec.version = '2.3.0'
  spec.summary = "UUID generator"
  spec.description = <<-EOF
UUID generator for producing universally unique identifiers based on RFC 4122
(http://www.ietf.org/rfc/rfc4122.txt).
EOF

  spec.authors << 'Assaf Arkin' << 'Eric Hodel'
  spec.email = 'assaf@labnotes.org'
  spec.homepage = 'http://github.com/assaf/uuid'

  spec.files = Dir['{bin,test,lib,docs}/**/*'] + ['README.rdoc', 'MIT-LICENSE', 'Rakefile', 'CHANGELOG', 'uuid.gemspec']
  spec.executables = "uuid"
  
  spec.has_rdoc = true
  spec.rdoc_options << '--main' << 'README.rdoc' << '--title' <<  'UUID generator' << '--line-numbers'
                       '--webcvs' << 'http://github.com/assaf/uuid'
  spec.extra_rdoc_files = ['README.rdoc', 'MIT-LICENSE']

  spec.add_dependency 'macaddr', ['~>1.0']
end
