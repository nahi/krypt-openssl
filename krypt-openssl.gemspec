Gem::Specification.new do |s|
  s.name = 'krypt-openssl'
  s.version = '0.0.1'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Martin Bosslet', 'Hiroshi Nakamura']
  s.email = 'nahi@ruby-lang.org'
  s.homepage = 'https://github.com/nahi/krypt-openssl'
  s.summary = %q{Runtime support libraries for Jenkins Ruby plugins}
  s.description = %q{I'll think of a better description later, but if you're reading this, then I haven't}
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"

  s.add_dependency 'krypt-core'
end
